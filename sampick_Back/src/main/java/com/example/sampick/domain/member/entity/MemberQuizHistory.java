package com.example.sampick.domain.member.entity;

import com.example.sampick.domain.quiz.entity.Quiz;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_quiz_history", indexes = {
        @Index(name = "idx_user_id", columnList = "user_id"),
        @Index(name = "idx_quiz_id", columnList = "quiz_id"),
        @Index(name = "idx_solved_at", columnList = "solved_at"),
        @Index(name = "idx_user_solved", columnList = "user_id, solved_at")
})
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberQuizHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "history_id")
    private Long historyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private Member member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "selected_answer", nullable = false)
    private Integer selectedAnswer;

    @Column(name = "is_correct", nullable = false)
    private Boolean isCorrect;

    @CreationTimestamp
    @Column(name = "solved_at", nullable = false, updatable = false)
    private LocalDateTime solvedAt;

    @Column(name = "time_spent_seconds")
    private Integer timeSpentSeconds;
}