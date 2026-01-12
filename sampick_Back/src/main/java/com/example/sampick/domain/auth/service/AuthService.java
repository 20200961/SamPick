package com.example.sampick.domain.auth.service;

import com.example.sampick.domain.auth.dto.AuthDto;
import com.example.sampick.domain.auth.dto.SignupRequest;
import com.example.sampick.domain.member.entity.Member;
import com.example.sampick.domain.member.repository.MemberRepository;
import com.example.sampick.global.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AuthService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    /**
     * 로그인
     */
    public AuthDto.LoginResponse login(AuthDto.LoginRequest request) {
        // 1. 이메일로 회원 조회
        Member member = memberRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("이메일 또는 비밀번호가 일치하지 않습니다."));

        // 2. 비밀번호 확인
        if (!passwordEncoder.matches(request.getPassword(), member.getPassword())) {
            throw new IllegalArgumentException("이메일 또는 비밀번호가 일치하지 않습니다.");
        }

        // 3. 활성 상태 확인
        if (!member.getIsActive()) {
            throw new IllegalArgumentException("비활성화된 계정입니다.");
        }

        // 4. JWT 토큰 생성
        String userId = String.valueOf(member.getUserId());
        String role = "USER";
        String token = jwtTokenProvider.generateToken(userId, role);

        // 5. 응답 반환
        return AuthDto.LoginResponse.builder()
                .token(token)
                .userId(userId)
                .userName(member.getName())
                .role(role)
                .build();
    }

    /**
     * 회원가입
     */
    @Transactional
    public Map<String, Object> signup(SignupRequest request) {
        // 1. 이메일 중복 체크
        if (memberRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 2. 회원 생성
        Member member = Member.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .name(request.getName())
                .isActive(true)
                .build();

        memberRepository.save(member);

        // 3. 응답 반환
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "회원가입이 완료되었습니다.");
        response.put("userId", member.getUserId());
        
        return response;
    }

    /**
     * 이메일 중복 확인
     */
    public Map<String, Object> checkEmailDuplicate(String email) {
        boolean available = !memberRepository.existsByEmail(email);
        
        Map<String, Object> response = new HashMap<>();
        response.put("available", available);
        response.put("message", available ? "사용 가능한 이메일입니다." : "이미 사용 중인 이메일입니다.");
        
        return response;
    }
}