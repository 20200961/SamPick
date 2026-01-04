package com.example.sampick.domain.member.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_badge",
        uniqueConstraints = @UniqueConstraint(name = "uk_user_badge", columnNames = {"user_id", "badge_id"}),
        indexes = {
                @Index(name = "idx_user_id", columnList = "user_id"),
                @Index(name = "idx_badge_id", columnList = "badge_id"),
                @Index(name = "idx_earned_at", columnList = "earned_at")
        }
)
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberBadge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_badge_id")
    private Long userBadgeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private Member member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "badge_id", nullable = false)
    private Member badge;

    @CreationTimestamp
    @Column(name = "earned_at", nullable = false, updatable = false)
    private LocalDateTime earnedAt;
}