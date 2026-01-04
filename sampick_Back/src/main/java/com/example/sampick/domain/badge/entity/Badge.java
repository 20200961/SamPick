package com.example.sampick.domain.badge.entity;

import com.example.sampick.domain.member.entity.MemberBadge;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "badge", indexes = {
        @Index(name = "idx_badge_type", columnList = "badge_type")
})
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Badge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "badge_id")
    private Long badgeId;

    @Column(name = "badge_name", nullable = false, unique = true, length = 100)
    private String badgeName;

    @Column(nullable = false, length = 10)
    private String emoji;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "badge_type", nullable = false, length = 50)
    private String badgeType;

    @Column(name = "requirement_value", nullable = false)
    private Integer requirementValue;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "badge", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MemberBadge> memberBadges = new ArrayList<>();
}