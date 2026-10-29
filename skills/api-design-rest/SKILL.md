---
name: api-design-rest
description: 现代化 RESTful API 规范与接口设计评审专家。指导设计符合 HTTP 语义、安全、易读、可扩展的 API 契约，包括资源路径设计、状态码映射、统一错误结构（RFC 7807）、分页与过滤标准。
---

# api-design-rest - 现代 RESTful API 规范与设计

## 核心目标

规范化 HTTP API 设计，提供符合业界最佳实践的 RESTful 架构准则，涵盖 URI 命名、HTTP 方法与状态码匹配、统一响应结构、错误处理标准（RFC 7807）、分页与版本控制。

## 触发场景

- 用户设计新接口或编写接口文档（例如："帮我设计一套电商订单系统的 API"）
- 评审已有接口定义的规范性与可演进性
- 统一前后端协作的契约规范与错误码体系

---

## 核心设计规范

### 1. 资源路径命名（URI）
- **名词复数**：使用表示资源集合的名词复数，严禁在 URI 中包含动词。
  - 正确：`GET /api/v1/orders`、`POST /api/v1/orders`
  - 错误：`GET /api/v1/getOrderList`、`POST /api/v1/createOrder`
- **全小写与中划线**：多单词使用 kebab-case，禁用下划线与驼峰命名。
  - 正确：`/api/v1/user-profiles`
  - 错误：`/api/v1/userProfiles`、`/api/v1/user_profiles`
- **层级表示从属关系**：
  - 获取某个用户的全部订单：`GET /api/v1/users/{user_id}/orders`
  - 获取某个用户特定订单项：`GET /api/v1/users/{user_id}/orders/{order_id}/items`
  - 注意：层级尽量不超过两级；超过时扁平化为顶级资源。

### 2. HTTP 方法语义映射

| 方法 | 语义 | 幂等性 | 安全性 | 成功返回状态码 |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | 读取资源（集合或单个） | 是 | 是 | `200 OK` |
| **POST** | 创建新子资源 / 触发特定复杂计算 | 否 | 否 | `201 Created`（通常附带 `Location` 头） |
| **PUT** | 全量替换覆盖资源 | 是 | 否 | `200 OK` 或 `204 No Content` |
| **PATCH** | 局部更新资源的部分字段 | 否（通常） | 否 | `200 OK` |
| **DELETE** | 删除资源 | 是 | 否 | `200 OK` 或 `204 No Content` |

### 3. HTTP 状态码精选

- **2xx 成功**
  - `200 OK`: 成功读取或更新。
  - `201 Created`: 资源创建成功。
  - `204 No Content`: 成功执行但无需返回正文（如 DELETE 操作）。
- **4xx 客户端错误**
  - `400 Bad Request`: 参数格式错误或基本校验失败。
  - `401 Unauthorized`: 未提供身份凭据或凭据失效。
  - `403 Forbidden`: 身份明确但无权访问该资源（越权）。
  - `404 Not Found`: 请求的资源或路径不存在。
  - `409 Conflict`: 资源状态冲突（如重复提交或并发版本冲突）。
  - `422 Unprocessable Entity`: 语义校验失败（如库存不足、密码复杂度不达标）。
  - `429 Too Many Requests`: 触发限流。
- **5xx 服务端错误**
  - `500 Internal Server Error`: 未捕获的服务端异常。
  - `502 / 503 / 504`: 网关与上游服务超时或不可用。

### 4. 统一错误响应标准（遵循 RFC 7807 Problem Details）
摒弃自造的 `{ code: -1, msg: "error" }` 包装，采用工业界公认的 RFC 7807 结构：

```json
{
  "type": "https://api.example.com/errors/insufficient-balance",
  "title": "账户余额不足",
  "status": 422,
  "detail": "当前账户可用余额为 12.50 元，不足以支付本次订单扣款 50.00 元。",
  "instance": "/api/v1/orders/ord_100293/payments",
  "invalid_params": [
    {
      "name": "amount",
      "reason": "超出可用额度"
    }
  ]
}
```

### 5. 分页、过滤与排序参数标准
- **游标分页 (推荐大数据量与高频变动流)**：
  - `GET /api/v1/feeds?limit=20&starting_after=feed_8932`
- **偏移量分页 (后台管理系统)**：
  - `GET /api/v1/users?page=2&page_size=20`
  - 响应包含：`items`, `total`, `page`, `page_size`, `total_pages`
- **排序**：
  - `GET /api/v1/products?sort=-created_at,price`（前缀 `-` 表示倒序）

---

## 接口设计模板示例

### 场景：用户订单管理

```http
### 1. 创建订单 (支持幂等)
POST /api/v1/orders
Content-Type: application/json
Idempotency-Key: 7b8b4a2c-90fc-4c28-98e3-5f048d88e05a

{
  "items": [
    { "sku_id": "sku_88291", "quantity": 2 }
  ],
  "address_id": "addr_99182"
}

HTTP/1.1 201 Created
Location: /api/v1/orders/ord_9901
Content-Type: application/json

{
  "id": "ord_9901",
  "status": "pending_payment",
  "total_amount": 199.00,
  "created_at": "2026-10-29T10:00:00Z"
}
```

---

## 质量自检清单

- [ ] URI 中是否绝对没有出现动词（如 `/get`, `/add`, `/update`）
- [ ] 资源名称是否为小写复数名词并使用中划线分隔
- [ ] 是否利用 HTTP 状态码表达请求结果，而非全部返回 200并在 Body 中塞错误码
- [ ] 关键写入操作是否支持幂等性设计（`Idempotency-Key`）
- [ ] 敏感数据（密码、密钥、身份证号）是否脱敏处理
