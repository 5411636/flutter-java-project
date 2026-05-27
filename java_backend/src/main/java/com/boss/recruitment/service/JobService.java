package com.boss.recruitment.service;

import com.boss.recruitment.entity.Job;
import com.boss.recruitment.repository.JobRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class JobService {

    private final JobRepository jobRepository;

    public Page<Job> searchJobs(String keyword, String city, Pageable pageable) {
        if (keyword != null && !keyword.isEmpty()) {
            if (city != null && !city.isEmpty()) {
                return jobRepository.findByTitleContainingAndCityAndActiveTrue(keyword, city, pageable);
            }
            return jobRepository.findByTitleContainingAndActiveTrue(keyword, pageable);
        }

        if (city != null && !city.isEmpty()) {
            return jobRepository.findByCityAndActiveTrue(city, pageable);
        }

        return jobRepository.findByActiveTrue(pageable);
    }

    public Job findById(Long id) {
        return jobRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("职位不存在"));
    }

    @Transactional
    public void incrementViewCount(Long id) {
        Job job = findById(id);
        job.setViewCount(job.getViewCount() + 1);
        jobRepository.save(job);
    }

    public List<Job> findHotJobs() {
        return jobRepository.findTop10ByHotTrueAndActiveTrueOrderByCreatedAtDesc();
    }

    public Page<Job> searchWithFilters(Map<String, Object> filters, Pageable pageable) {
        // 这里可以使用 Specification 进行复杂查询
        // 简化版本返回所有
        return jobRepository.findByActiveTrue(pageable);
    }
}
