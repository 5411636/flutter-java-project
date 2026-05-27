package com.boss.recruitment.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class LoginRequest {

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    @NotBlank(message = "验证码/密码不能为空")
    private String credential;

    private LoginType type = LoginType.CODE;

    public enum LoginType {
        CODE,     // 验证码登录
        PASSWORD  // 密码登录
    }
}
