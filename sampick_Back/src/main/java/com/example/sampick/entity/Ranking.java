package com.example.sampick.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "ranking",
        uniqueConstraints = @UniqueConstraint(name = "uk_user_period", columnNames = {"user_id", "period_type", "period_start"}),
        indexes = {
                @Index(name = "idx_user_id", columnList = "user_id"),
                @Index(name = "idx_period_type", columnList = "period_type"),
                @Index(name = "idx_rank_position", columnList = "rank_position"),
                @Index(name = "idx_total_score", columnList = "total_score")
        }
)
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ranking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ranking_id")
    private Long rankingId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "total_score")
    private Integer totalScore = 0;

    @Column(name = "rank_position")
    private Integer rankPosition;

    @Column(name = "period_type", nullable = false, length = 20)
    private String periodType;

    @Column(name = "period_start")
    private LocalDate periodStart;

    @Column(name = "period_end")
    private LocalDate periodEnd;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}