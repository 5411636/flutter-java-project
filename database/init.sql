-- 创建数据库
CREATE DATABASE IF NOT EXISTS boss_recruitment DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE boss_recruitment;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(11) NOT NULL UNIQUE COMMENT '手机号',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密）',
    name VARCHAR(50) COMMENT '姓名',
    avatar_url VARCHAR(200) COMMENT '头像URL',
    expected_position VARCHAR(100) COMMENT '期望职位',
    city VARCHAR(50) COMMENT '城市',
    expected_salary VARCHAR(20) COMMENT '期望薪资',
    job_status VARCHAR(20) COMMENT '求职状态',
    role ENUM('SEEKER', 'HR') NOT NULL DEFAULT 'SEEKER' COMMENT '角色',
    active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_phone (phone),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 公司表
CREATE TABLE IF NOT EXISTS companies (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '公司名称',
    logo_url VARCHAR(500) COMMENT 'Logo URL',
    industry VARCHAR(50) COMMENT '行业',
    scale VARCHAR(50) COMMENT '规模',
    financing VARCHAR(50) COMMENT '融资状态',
    intro TEXT COMMENT '公司简介',
    address VARCHAR(200) COMMENT '地址',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公司表';

-- 职位表
CREATE TABLE IF NOT EXISTS jobs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL COMMENT '职位名称',
    salary VARCHAR(50) NOT NULL COMMENT '薪资',
    city VARCHAR(50) COMMENT '城市',
    experience VARCHAR(20) COMMENT '经验要求',
    education VARCHAR(20) COMMENT '学历要求',
    job_type VARCHAR(20) COMMENT '工作类型',
    description TEXT COMMENT '职位描述',
    skills VARCHAR(500) COMMENT '技能要求（JSON）',
    welfare VARCHAR(500) COMMENT '福利（JSON）',
    active BOOLEAN DEFAULT TRUE COMMENT '是否有效',
    hot BOOLEAN DEFAULT FALSE COMMENT '是否热门',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    company_id BIGINT COMMENT '公司ID',
    hr_id BIGINT COMMENT 'HR用户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (hr_id) REFERENCES users(id),
    INDEX idx_title (title),
    INDEX idx_city (city),
    INDEX idx_hot (hot),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='职位表';

-- 教育经历表
CREATE TABLE IF NOT EXISTS educations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    school VARCHAR(100) NOT NULL COMMENT '学校',
    major VARCHAR(100) COMMENT '专业',
    degree VARCHAR(20) COMMENT '学历',
    start_time VARCHAR(20) COMMENT '开始时间',
    end_time VARCHAR(20) COMMENT '结束时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教育经历表';

-- 工作经历表
CREATE TABLE IF NOT EXISTS work_experiences (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    company VARCHAR(100) NOT NULL COMMENT '公司',
    position VARCHAR(100) NOT NULL COMMENT '职位',
    description TEXT COMMENT '工作描述',
    start_time VARCHAR(20) COMMENT '开始时间',
    end_time VARCHAR(20) COMMENT '结束时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作经历表';

-- 收藏表
CREATE TABLE IF NOT EXISTS favorites (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    job_id BIGINT NOT NULL COMMENT '职位ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    UNIQUE KEY uk_user_job (user_id, job_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- 投递记录表
CREATE TABLE IF NOT EXISTS applications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    job_id BIGINT NOT NULL COMMENT '职位ID',
    status ENUM('PENDING', 'VIEWED', 'INTERVIEW', 'REJECTED') DEFAULT 'PENDING' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '投递时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='投递记录表';

-- 插入测试数据

-- 插入公司
INSERT INTO companies (name, logo_url, industry, scale, financing, intro) VALUES
('字节跳动', 'https://example.com/bytedance.png', '互联网/移动互联网', '10000人以上', '已上市', '字节跳动成立于2012年3月，是最早将人工智能应用于移动互联网场景的科技企业之一。'),
('阿里巴巴', 'https://example.com/alibaba.png', '互联网/电子商务', '10000人以上', '已上市', '阿里巴巴集团是一家以电子商务为核心的互联网公司。'),
('腾讯', 'https://example.com/tencent.png', '互联网/游戏', '10000人以上', '已上市', '腾讯是中国最大的互联网综合服务提供商之一。');

-- 插入用户（HR）
INSERT INTO users (phone, password, name, role) VALUES
('13800138001', '$2a$10$XQsGPl3qhKxLq5DGrDPGxeKITfJlPXhfYR1234567890ABCDEFG', '张经理', 'HR'),
('13800138002', '$2a$10$XQsGPl3qhKxLq5DGrDPGxeKITfJlPXhfYR1234567890ABCDEFG', '李HR', 'HR');

-- 插入职位
INSERT INTO jobs (title, salary, city, experience, education, job_type, description, skills, welfare, hot, company_id, hr_id) VALUES
('高级前端开发工程师', '25-40K·15薪', '北京·朝阳区', '5-10年', '本科', '全职',
'负责公司核心产品的前端开发工作，参与技术架构设计。要求精通React/Vue，有大型项目经验。',
'["React","Vue","TypeScript","Node.js"]',
'["五险一金","年终奖","股票期权","带薪年假","免费三餐"]',
TRUE, 1, 1),
('Java后端架构师', '40-70K·16薪', '杭州·余杭区', '10年以上', '本科', '全职',
'负责后端架构设计与优化，带领团队完成核心业务系统开发。',
'["Java","Spring Boot","微服务","MySQL"]',
'["六险一金","免费三餐","健身房","下午茶"]',
FALSE, 2, 2);
