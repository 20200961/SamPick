package com.example.sampick.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "daily_progress",
        uniqueConstraints = @UniqueConstraint(name = "uk_user_date", columnNames = {"user_id", "progress_date"}),
        indexes = {
                @Index(name = "idx_progress_date", columnList = "progress_date"),
                @Index(name = "idx_user_date", columnList = "user_id, progress_date")
        }
)
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DailyProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "progress_id")
    private Long progressId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "progress_date", nullable = false)
    private LocalDate progressDate;

    @Column(name = "problems_solved")
    private Integer problemsSolved = 0;

    @Column(name = "daily_goal")
    private Integer dailyGoal = 3;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}