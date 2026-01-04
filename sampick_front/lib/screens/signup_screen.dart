import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _isEmailChecked = false;
  bool _isEmailAvailable = false;
  bool _isCheckingEmail = false;
  String? _selectedSource;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final String baseUrl = 'http://localhost:8080/api/auth';

  // 유입경로 옵션
  final List<String> _sourceOptions = [
    '검색 (Google, Naver 등)',
    'SNS (Instagram, Facebook 등)',
    '지인 추천',
    '광고',
    '블로그/커뮤니티',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // 이메일 입력 변경 감지
    _emailController.addListener(() {
      if (_isEmailChecked) {
        setState(() {
          _isEmailChecked = false;
          _isEmailAvailable = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 이메일 중복 확인
  Future<void> _checkEmailDuplicate() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar('이메일을 입력해주세요', isError: true);
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showSnackBar('올바른 이메일 형식이 아닙니다', isError: true);
      return;
    }

    setState(() => _isCheckingEmail = true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/check-email?email=${_emailController.text}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isAvailable = data['available'] ?? false;

        setState(() {
          _isEmailChecked = true;
          _isEmailAvailable = isAvailable;
        });

        if (isAvailable) {
          _showSnackBar('사용 가능한 이메일입니다', isError: false);
        } else {
          _showSnackBar('이미 사용 중인 이메일입니다', isError: true);
        }
      } else {
        _showSnackBar('중복 확인에 실패했습니다', isError: true);
      }
    } catch (e) {
      _showSnackBar('네트워크 오류가 발생했습니다', isError: true);
    } finally {
      setState(() => _isCheckingEmail = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[400] : const Color(0xFF87CEEB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (!_agreeToTerms) {
      _showSnackBar('이용약관에 동의해주세요', isError: true);
      return;
    }

    if (!_isEmailChecked || !_isEmailAvailable) {
      _showSnackBar('이메일 중복 확인을 해주세요', isError: true);
      return;
    }

    if (_selectedSource == null) {
      _showSnackBar('유입경로를 선택해주세요', isError: true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'source': _selectedSource,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          if (mounted) {
            _showSnackBar('회원가입이 완료되었습니다!', isError: false);
            Navigator.pop(context);
          }
        } else {
          final data = jsonDecode(response.body);
          if (mounted) {
            _showSnackBar(data['message'] ?? '회원가입에 실패했습니다', isError: true);
          }
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('네트워크 오류: $e', isError: true);
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF87CEEB)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CEEB),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '새로운 계정을 만들어보세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 이름 입력
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: '이름',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF87CEEB),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F8FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF87CEEB),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 이메일 입력 + 중복확인 버튼
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: '이메일',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              floatingLabelStyle: const TextStyle(
                                color: Color(0xFF87CEEB),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF0F8FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF87CEEB),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              suffixIcon: _isEmailChecked
                                  ? Icon(
                                      _isEmailAvailable
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: _isEmailAvailable
                                          ? Colors.green
                                          : Colors.red,
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이메일을 입력해주세요';
                              }
                              if (!value.contains('@')) {
                                return '올바른 이메일 형식이 아닙니다';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isCheckingEmail
                                ? null
                                : _checkEmailDuplicate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF87CEEB),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: _isCheckingEmail
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    '중복\n확인',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF87CEEB),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F8FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF87CEEB),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF87CEEB),
                          ),
                          onPressed: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        if (value.length < 8) {
                          return '비밀번호는 8자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 비밀번호 확인
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF87CEEB),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F8FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF87CEEB),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF87CEEB),
                          ),
                          onPressed: () {
                            setState(
                              () => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible,
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 입력해주세요';
                        }
                        if (value != _passwordController.text) {
                          return '비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 유입경로 선택 (드롭다운)
                    DropdownButtonFormField<String>(
                      value: _selectedSource,
                      decoration: InputDecoration(
                        labelText: '유입경로',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF87CEEB),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F8FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF87CEEB),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      hint: Text(
                        '어떻게 알게 되셨나요?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF87CEEB),
                      ),
                      items: _sourceOptions.map((String source) {
                        return DropdownMenuItem<String>(
                          value: source,
                          child: Text(source),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSource = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '유입경로를 선택해주세요';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // 약관 동의
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() => _agreeToTerms = value ?? false);
                            },
                            activeColor: const Color(0xFF87CEEB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _agreeToTerms = !_agreeToTerms);
                            },
                            child: Text(
                              '이용약관 및 개인정보처리방침에 동의합니다',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 회원가입 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87CEEB),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                '가입하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
