package com.example.sampick.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "quiz_option",
        uniqueConstraints = @UniqueConstraint(name = "uk_quiz_option", columnNames = {"quiz_id", "option_index"}),
        indexes = @Index(name = "idx_quiz_id", columnList = "quiz_id")
)
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuizOption {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "option_id")
    private Long optionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "option_index", nullable = false)
    private Integer optionIndex;

    @Column(name = "option_text", nullable = false, length = 500)
    private String optionText;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}