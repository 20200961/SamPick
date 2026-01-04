package com.example.sampick.domain.auth.service;

import com.example.sampick.domain.auth.dto.AuthDto;
import com.example.sampick.domain.member.entity.Member;
import com.example.sampick.domain.member.repository.MemberRepository;
import com.example.sampick.global.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AuthService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

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

        // 4. JWT 토큰 생성 (userId를 String으로 변환)
        String userId = String.valueOf(member.getUserId());
        String role = "USER"; // 기본 역할
        String token = jwtTokenProvider.generateToken(userId, role);

        // 5. 응답 반환
        return AuthDto.LoginResponse.builder()
                .token(token)
                .userId(userId)
                .userName(member.getName())
                .role(role)
                .build();
    }
}