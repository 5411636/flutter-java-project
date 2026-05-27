package com.boss.recruitment.repository;

import com.boss.recruitment.entity.Job;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JobRepository extends JpaRepository<Job, Long> {

    Page<Job> findByActiveTrue(Pageable pageable);

    Page<Job> findByCityAndActiveTrue(String city, Pageable pageable);

    Page<Job> findByTitleContainingAndActiveTrue(String title, Pageable pageable);

    Page<Job> findByTitleContainingAndCityAndActiveTrue(String title, String city, Pageable pageable);

    List<Job> findTop10ByHotTrueAndActiveTrueOrderByCreatedAtDesc();
}
