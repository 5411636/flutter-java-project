package com.boss.recruitment.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "jobs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Job {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String title;

    @Column(nullable = false, length = 50)
    private String salary;

    @Column(length = 50)
    private String city;

    @Column(length = 20)
    private String experience;

    @Column(length = 20)
    private String education;

    @Column(length = 20)
    private String jobType; // 全职、兼职、实习

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String skills; // JSON格式存储技能标签

    @Column(length = 500)
    private String welfare; // JSON格式存储福利标签

    @Column(nullable = false)
    private Boolean active = true;

    @Column(nullable = false)
    private Boolean hot = false;

    private Integer viewCount = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hr_id")
    private User hr;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
