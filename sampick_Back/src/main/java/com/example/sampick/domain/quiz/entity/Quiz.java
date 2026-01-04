package com.example.sampick.domain.quiz.entity;

import com.example.sampick.domain.member.entity.MemberQuizHistory;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "quiz", indexes = {
        @Index(name = "idx_category", columnList = "category"),
        @Index(name = "idx_difficulty", columnList = "difficulty"),
        @Index(name = "idx_active", columnList = "is_active")
})
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "quiz_id")
    private Long quizId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(name = "correct_answer", nullable = false)
    private Integer correctAnswer;

    @Column(length = 50)
    private String category;

    @Column(length = 20)
    private String difficulty;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<QuizOption> options = new ArrayList<>();

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MemberQuizHistory> histories = new ArrayList<>();
}