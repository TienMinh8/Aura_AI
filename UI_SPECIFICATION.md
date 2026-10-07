# AURA (MEMORY AI) - UI/UX SPECIFICATION & DESIGN SYSTEM MEMORY
> **Bản ghi nhớ kiến trúc & giao diện chi tiết** được trích xuất hoàn chỉnh từ 28 ảnh chụp màn hình native iOS gốc. Tài liệu này đóng vai trò là "Single Source of Truth", không cần phải đọc lại các file ảnh.

---

## 1. HỆ THỐNG MÀU SẮC (OLED Dark & Amber Palette)
- **Background chính (OLED Black)**: `#09090B` (Đen sâu tuyệt đối cho màn hình Super Retina OLED).
- **Surface / Card Background**: `#18181A` hoặc `#1C1C1E`.
- **Card Hover / Active Pill**: `#2C2C2E` đến `#38383D`.
- **Viền Subtle Border**: `rgba(255, 255, 255, 0.10)` đến `rgba(255, 255, 255, 0.15)` (độ dày 0.5 - 0.8pt).
- **Màu nhấn chủ đạo (Primary Accent)**:
  - Amber Orange: `#FF9500`
  - Amber Hover: `#E08300`
  - Amber Soft Glow: `rgba(255, 149, 0, 0.18)`
- **Màu chức năng & Trạng thái**:
  - Green (Active / Online / Checked): `#34C759`
  - Blue (Telegram / Links): `#0A84FF`
  - Red / Coral (Sign out / Warnings): `#FF453A`
- **Màu chữ (Typography Colors)**:
  - Text Primary: `#FFFFFF` / `#F4F4F5`
  - Text Secondary: `#A1A1AA`
  - Text Muted: `#71717A`

---

## 2. TYPOGRAPHY & PHONG CÁCH
- **Display Serif Title**: `Instrument Serif` / `New York` (phục vụ tiêu đề ngày tháng như *"Oct 2026"*, *"Minh"* trên Profile, tiêu đề Tasks). Kích thước: 36 - 40pt.
- **Body & Controls**: `SF Pro Text` / `SF Pro Display` (hoặc `Plus Jakarta Sans`). Kích thước: 13 - 17pt, FontWeight: `.medium`, `.semibold`.
- **Numbers & Counters**: `SF Pro Rounded` (cho đồng hồ, số đếm, ngày tháng).

---

## 3. THANH ĐIỀU HƯỚNG CHÍNH (FLOATING CAPSULE TAB BAR)
- **Vị trí**: Lơ lửng cách đáy màn hình (`bottom: 10pt`, `horizontal padding: 16pt`).
- **Hình dáng**: Viên thuốc nổi (Floating Pill), bo góc `38 - 40pt`, chiều cao `68 - 72pt`.
- **Chất liệu**: Kính mờ siêu thực (Liquid Glassmorphism), `BackdropFilter` / `.ultraThinMaterial` phủ màu `#1E1E22` (độ mờ 92%), viền sáng `white.opacity(0.12)`.
- **Thứ tự 4 Tab chính**:
  1. **Chat** (Index 0): Icon SF Symbol `message.fill` hoặc bong bóng bo góc có 3 vạch ngang.
  2. **Today** (Index 1): Icon SF Symbol `calendar` (khung lịch có ma trận 12 chấm ngày).
  3. **Tasks** (Index 2): Icon SF Symbol `checklist` / hộp lưu trữ có dấu tick chữ V.
  4. **Profile** (Index 3): Icon SF Symbol `person.crop.circle.fill`.
- **Trạng thái Active**:
  - Tab được bao bọc bởi một viên thuốc màu xám `#38383D`, kích thước `w: 80pt, h: 56pt`.
  - Icon & nhãn chữ đổi sang màu **Cam hổ phách `#FF9500`**.
  - Xúc giác: Kích hoạt `UIImpactFeedbackGenerator(style: .light)`.

---

## 4. CHI TIẾT 4 MÀN HÌNH CHÍNH

### Tab 1: Chat View (IMG_8722, IMG_8730)
- **Top Header**:
  - Capsule trung tâm: *"Nova - Memory AI"* kèm đèn trạng thái online màu xanh lá `#34C759`.
  - Phía dưới là thanh cuộn ngang gợi ý chủ đề: `[📰 News]`, `[🌧️ Weather]`, `[🪴 Motivation]`, `[📈 Price]`.
- **Nội dung Chat AI**:
  - Lời thoại từ Nova: *"New event — today at 4:00 PM. What is it?"*.
  - Hướng dẫn kết nối OpenWeatherMap (bước 1-4, link cam, khóa bảo mật 🔒).
  - Thẻ tag sự kiện: `[📅 New event · Today at 16:00 ✕]`.
- **Thanh Input ở đáy**:
  - Textfield bo tròn góc `24pt`: Placeholder *"Name the event..."*.
  - Các nút: `(+)` đính kèm, `(@)` mention không gian, `(🎙️)` ghi âm giọng nói.

### Tab 2: Today View (IMG_8721, IMG_8724, 8725, 8727, 8729)
- **Top Header**: Tiêu đề *"Oct 2026"*, bên phải là nút icon chuyển chế độ xem (Stack Layers).
- **Dải ngày trong tuần (Weekly Strip)**:
  - SA (3), SU (4), MO (5), TU (6), WE (7), TH (8), FR (9).
  - Ngày đang chọn (TU 6): Hình tròn màu cam rực `#FF9500`, số 6 màu đen nổi bật.
- **Empty State Hero**:
  - Card mờ bo góc tròn với icon chuông thông báo 🔔 và nút tick tròn xanh lá.
  - Dòng chữ: *"Nothing planned today"*, *"Ask the chat to plan it — or add one below."*.
  - Nút chính: Pill màu cam rực `[+ Add event]`.
  - Link phụ: *"☀️🥛📜 What else Memory can do >"*.
- **Chế độ xem**: Nút gạt chuyển đổi `[List View]` hoặc `[Timeline Grid (1 | 3 | 7 ngày)]`.
- **Floating Action Button (+)**: Nút tròn màu cam `#FF9500` ở góc dưới phải. Khi bấm mở Menu Popover chọn:
  - `Reminder 🔔`
  - `Task 🔁`
  - `Event 📅`
  - `Quick thought 💡`

### Tab 3: Tasks View (IMG_8728)
- **Top Header**: Chữ serif lớn *"Tasks"*, bên phải có nút tròn `(+)`.
- **Hero Element - Retro Analog Clock**:
  - Chiếc đồng hồ báo thức kim cổ điển màu vàng kem, hai chuông gõ trên đỉnh.
  - Vẽ bằng kim giờ, kim phút động.
- **Tiêu đề phụ**: *"Let Nova take on the routine"*, *"Turn one on — it'll arrive by itself, every day."*.
- **Danh sách Routine tự động**:
  - `Morning brief 08:00`: "Weather, plans and news" (Icon ☀️, nút toggle "Turn on")
  - `Bitcoin price 09:00`: "Price and 24h change" (Icon 📈, nút toggle "Turn on")
  - `Motivation 08:30`: "A boost for the day" (Icon 🪴, nút toggle "Turn on")
  - `Weather 07:30`: "The day's forecast" (Icon 🌧️, nút toggle "Turn on")
  - `AI news 09:00`: "The day's top stories" (Icon 📰, nút toggle "Turn on")
  - `Something else`: "Describe it in chat — Nova will set it up" (Nút mở Chat).

### Tab 4: Profile View (IMG_8731, IMG_8732, 8733)
- **Hero Avatar**: Vầng thái dương rực sáng (Sun Disk màu vàng cam kèm các tia nắng tỏa sáng nhẹ nhàng).
- **Chữ cái đại diện**: Chữ "M" ở giữa, tên người dùng *"Minh"*.
- **Không gian chia sẻ (Spaces)**:
  - *"Share events with family or a team"*.
  - 3 Spaces: `Family 🏠`, `Work 💼`, `Home 🪴` (mỗi space có icon badge `(+)`).
  - Hàng nhập mã: *"Enter invite code >"*.
- **Mục cài đặt (Assistant & Sync)**:
  - `Capabilities`: Mở sheet tính năng.
  - `Calendars`: Mở sheet đồng bộ lịch Apple/Google.
  - `Connected apps`: Mở sheet kết nối Telegram, Slack, Notion...
  - `Token usage`: Mở sheet số dư ($9.93) & nạp thẻ.
  - `Widgets`: Mở sheet xem trước tiện ích Small/Medium/Large.
  - `Live Activities`: Mở sheet đếm ngược Dynamic Island.
- **Nút Sign out**: Màu đỏ cảnh báo `#FF453A`.

---

## 5. FLOW ONBOARDING 5 BƯỚC & PAYWALL (IMG_8712 - IMG_8720)
1. **Step 1 - Chat**: *"Talk to Nova like a friend"* — Mô phỏng bong bóng chat.
2. **Step 2 - Apps**: *"Connect what you use"* — Logo Telegram, Slack, Notion...
3. **Step 3 - Routine**: *"Never miss your morning rhythm"* — Preview thông báo buổi sáng.
4. **Step 4 - Notification**: *"Stay on top with Live Activities"* — Dynamic Island preview.
5. **Step 5 - Paywall Pro**:
   - Tiêu đề: *"Unlock Memory AI Unlimited"*.
   - 2 Lựa chọn:
     - `Yearly`: $59.99/năm (tiết kiệm 60%, 3 ngày dùng thử miễn phí).
     - `Weekly`: $5.99/tuần.
   - Nút CTA: Pill vàng cam `[Start 3-Day Free Trial]`.

---

## 6. CHI TIẾT 6 SUB-MODAL SHEETS
1. **CapabilitiesSheet (IMG_8723)**: Thẻ Instant Reminder, Auto-enrichment, 8 ô danh mục chức năng.
2. **ConnectedAppsSheet (IMG_8735)**: Telegram, X (Twitter), Slack, Discord, Zoom, GCal, Notion.
3. **UsageSheet (IMG_8737)**: Số dư $9.93, 4 gói nạp token ($5, $20, $50, $500).
4. **WidgetsSheet (IMG_8742-8744)**: Xem trước 3 kích cỡ Home Widget (Small, Medium, Large).
5. **LiveActivitiesSheet (IMG_8739, 8741)**: Demo thanh Dynamic Island đếm ngược thời gian thực, 18 icon danh mục.
6. **CalendarSyncSheet (IMG_8734)**: Switch 2 chiều Export to Apple Calendar & Import from Apple Calendar.
