package com.boss.recruitment.service;

import com.boss.recruitment.entity.User;
import com.boss.recruitment.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public Optional<User> findByPhone(String phone) {
        return userRepository.findByPhone(phone);
    }

    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
    }

    @Transactional
    public User createUser(String phone) {
        User user = new User();
        user.setPhone(phone);
        user.setPassword(passwordEncoder.encode("123456")); // 默认密码
        user.setRole(User.UserRole.SEEKER);
        user.setActive(true);
        return userRepository.save(user);
    }

    @Transactional
    public User updateUser(Long id, User userDetails) {
        User user = findById(id);

        if (userDetails.getName() != null) {
            user.setName(userDetails.getName());
        }
        if (userDetails.getAvatarUrl() != null) {
            user.setAvatarUrl(userDetails.getAvatarUrl());
        }
        if (userDetails.getExpectedPosition() != null) {
            user.setExpectedPosition(userDetails.getExpectedPosition());
        }
        if (userDetails.getCity() != null) {
            user.setCity(userDetails.getCity());
        }
        if (userDetails.getExpectedSalary() != null) {
            user.setExpectedSalary(userDetails.getExpectedSalary());
        }
        if (userDetails.getJobStatus() != null) {
            user.setJobStatus(userDetails.getJobStatus());
        }

        return userRepository.save(user);
    }
}
