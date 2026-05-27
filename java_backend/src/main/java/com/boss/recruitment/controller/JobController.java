package com.boss.recruitment.controller;

import com.boss.recruitment.dto.ApiResponse;
import com.boss.recruitment.entity.Job;
import com.boss.recruitment.service.JobService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Tag(name = "职位管理", description = "职位相关接口")
@RestController
@RequestMapping("/api/jobs")
@RequiredArgsConstructor
public class JobController {

    private final JobService jobService;

    @Operation(summary = "获取职位列表")
    @GetMapping
    public ApiResponse<Page<Job>> getJobs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String keyword
    ) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Page<Job> jobs = jobService.searchJobs(keyword, city, pageRequest);
        return ApiResponse.success(jobs);
    }

    @Operation(summary = "获取职位详情")
    @GetMapping("/{id}")
    public ApiResponse<Job> getJobDetail(@PathVariable Long id) {
        Job job = jobService.findById(id);
        jobService.incrementViewCount(id);
        return ApiResponse.success(job);
    }

    @Operation(summary = "获取热门职位")
    @GetMapping("/hot")
    public ApiResponse<?> getHotJobs() {
        var jobs = jobService.findHotJobs();
        return ApiResponse.success(jobs);
    }

    @Operation(summary = "搜索职位")
    @PostMapping("/search")
    public ApiResponse<Page<Job>> searchJobs(
            @RequestBody Map<String, Object> filters,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Page<Job> jobs = jobService.searchWithFilters(filters, pageRequest);
        return ApiResponse.success(jobs);
    }
}
