# Boss直聘风格招聘平台

## 技术栈

### 前端
- **Flutter 3.16+** - 跨平台移动端开发
- **Dart** - 编程语言
- **Provider/GetX** - 状态管理
- **Dio** - HTTP 客户端

### 后端
- **Java 17** - 编程语言
- **Spring Boot 3.x** - 后端框架
- **Spring Security + JWT** - 认证授权
- **Spring Data JPA** - ORM 框架
- **MySQL 8.0+** - 数据库

## 项目结构

```
flutter-java-project/
├── flutter_app/          # Flutter 移动端
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/      # 数据模型
│   │   ├── pages/       # 页面
│   │   ├── services/    # API 服务
│   │   ├── providers/   # 状态管理
│   │   └── widgets/     # 自定义组件
│   └── pubspec.yaml
│
└── java_backend/         # Java 后端
    ├── src/main/java/com/boss/
    │   ├── controller/  # REST 控制器
    │   ├── service/     # 业务逻辑
    │   ├── repository/  # 数据访问
    │   ├── entity/      # 数据库实体
    │   ├── dto/         # 数据传输对象
    │   ├── config/      # 配置类
    │   └── security/    # 安全配置
    └── pom.xml
```

## 快速开始

### 后端启动
```bash
cd java_backend
mvn clean install
mvn spring-boot:run
```

### 前端启动
```bash
cd flutter_app
flutter pub get
flutter run
```

## API 文档
访问: http://localhost:8080/swagger-ui.html
