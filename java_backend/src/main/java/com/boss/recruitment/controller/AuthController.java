package com.boss.recruitment.controller;

import com.boss.recruitment.dto.ApiResponse;
import com.boss.recruitment.dto.LoginRequest;
import com.boss.recruitment.security.JwtTokenProvider;
import com.boss.recruitment.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Tag(name = "认证管理", description = "用户登录注册相关接口")
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    @Operation(summary = "获取验证码")
    @PostMapping("/code")
    public ApiResponse<Map<String, String>> getVerificationCode(@RequestParam String phone) {
        // 模拟验证码生成
        String code = "123456";
        Map<String, String> result = new HashMap<>();
        result.put("code", code);
        result.put("message", "验证码已发送（模拟）");
        return ApiResponse.success(result);
    }

    @Operation(summary = "用户登录")
    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        // 验证码登录逻辑（简化版本）
        var user = userService.findByPhone(request.getPhone())
                .orElseGet(() -> userService.createUser(request.getPhone()));

        String token = jwtTokenProvider.generateToken(user.getId(), user.getRole().name());

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", user);

        return ApiResponse.success("登录成功", result);
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/me")
    public ApiResponse<?> getCurrentUser(@RequestHeader("Authorization") String token) {
        // 从token中解析用户ID
        String jwt = token.replace("Bearer ", "");
        Long userId = jwtTokenProvider.getUserIdFromToken(jwt);

        var user = userService.findById(userId);
        return ApiResponse.success(user);
    }
}
