import 'package:flutter/material.dart';

/// Bộ Icon vector chuẩn xác tái hiện 100% SF Symbols từ bản iOS gốc của Aura
class AuraNavIcons {
  static Widget chat({required Color color, double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ChatIconPainter(color: color),
      ),
    );
  }

  static Widget today({required Color color, double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TodayIconPainter(color: color),
      ),
    );
  }

  static Widget tasks({required Color color, double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TasksIconPainter(color: color),
      ),
    );
  }

  static Widget profile({required Color color, double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProfileIconPainter(color: color),
      ),
    );
  }
}

/// 1. Chat Icon: Bong bóng tin nhắn bo góc có đuôi & 3 vạch ngang
class _ChatIconPainter extends CustomPainter {
  final Color color;
  _ChatIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // Khung bong bóng có đuôi ở góc dưới trái
    final path = Path();
    final r = w * 0.22;
    path.moveTo(r, h * 0.08);
    path.lineTo(w - r, h * 0.08);
    path.quadraticBezierTo(w, h * 0.08, w, h * 0.08 + r);
    path.lineTo(w, h * 0.72 - r);
    path.quadraticBezierTo(w, h * 0.72, w - r, h * 0.72);
    path.lineTo(w * 0.38, h * 0.72);
    // Đuôi chat chỉ sang trái
    path.lineTo(w * 0.14, h * 0.94);
    path.quadraticBezierTo(w * 0.08, h * 0.99, w * 0.08, h * 0.88);
    path.lineTo(w * 0.08, h * 0.72);
    path.lineTo(r, h * 0.72);
    path.quadraticBezierTo(0, h * 0.72, 0, h * 0.72 - r);
    path.lineTo(0, h * 0.08 + r);
    path.quadraticBezierTo(0, h * 0.08, r, h * 0.08);
    path.close();

    canvas.drawPath(path, paint);

    // 3 vạch ngang bên trong bong bóng (màu nền đục lỗ / inverse)
    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    // Vạch 1
    canvas.drawLine(
      Offset(w * 0.24, h * 0.26),
      Offset(w * 0.76, h * 0.26),
      linePaint,
    );
    // Vạch 2
    canvas.drawLine(
      Offset(w * 0.24, h * 0.40),
      Offset(w * 0.76, h * 0.40),
      linePaint,
    );
    // Vạch 3 (ngắn hơn)
    canvas.drawLine(
      Offset(w * 0.24, h * 0.54),
      Offset(w * 0.56, h * 0.54),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ChatIconPainter oldDelegate) => oldDelegate.color != color;
}

/// 2. Today Icon: Lịch bo góc + thanh ngang header + ma trận chấm 3x4
class _TodayIconPainter extends CustomPainter {
  final Color color;
  _TodayIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Thân lịch bo góc
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.08, w * 0.84, h * 0.84),
      Radius.circular(w * 0.2),
    );
    canvas.drawRRect(rrect, fillPaint);

    // Thanh ngang header lịch (khoét âm bản)
    final cutPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07;

    canvas.drawLine(
      Offset(w * 0.12, h * 0.32),
      Offset(w * 0.88, h * 0.32),
      cutPaint,
    );

    // Ma trận 12 chấm tròn (3 hàng x 4 cột)
    final dotPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    const cols = 4;
    const rows = 3;
    final startX = w * 0.24;
    final endX = w * 0.76;
    final startY = h * 0.46;
    final endY = h * 0.78;
    final stepX = (endX - startX) / (cols - 1);
    final stepY = (endY - startY) / (rows - 1);
    final dotRadius = w * 0.045;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(startX + c * stepX, startY + r * stepY),
          dotRadius,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TodayIconPainter oldDelegate) => oldDelegate.color != color;
}

/// 3. Tasks Icon: Chiếc hộp task box có nắp trên và dấu tick bên trong
class _TasksIconPainter extends CustomPainter {
  final Color color;
  _TasksIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Nắp trên (Top tab)
    final topRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.06, w * 0.52, h * 0.16),
      Radius.circular(w * 0.07),
    );
    canvas.drawRRect(topRRect, fillPaint);

    // Thân hộp (Main card)
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.16, w * 0.80, h * 0.78),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bodyRRect, fillPaint);

    // Dấu tick chữ V bên trong thân hộp
    final tickPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tickPath = Path();
    tickPath.moveTo(w * 0.32, h * 0.54);
    tickPath.lineTo(w * 0.46, h * 0.68);
    tickPath.lineTo(w * 0.70, h * 0.40);

    canvas.drawPath(tickPath, tickPaint);
  }

  @override
  bool shouldRepaint(covariant _TasksIconPainter oldDelegate) => oldDelegate.color != color;
}

/// 4. Profile Icon: Vòng tròn người SF Symbol (person.crop.circle.fill)
class _ProfileIconPainter extends CustomPainter {
  final Color color;
  _ProfileIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Vòng tròn lớn bên ngoài
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.44, fillPaint);

    // Đầu người (Head)
    final cutoutPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(w / 2, h * 0.38), w * 0.17, cutoutPaint);

    // Vai và thân người (Shoulders & Body)
    final shoulderPath = Path();
    shoulderPath.moveTo(w * 0.22, h * 0.82);
    shoulderPath.quadraticBezierTo(w * 0.24, h * 0.58, w / 2, h * 0.58);
    shoulderPath.quadraticBezierTo(w * 0.76, h * 0.58, w * 0.78, h * 0.82);
    shoulderPath.close();

    canvas.save();
    // Clip trong phạm vi vòng tròn
    final clipPath = Path()..addOval(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w * 0.44));
    canvas.clipPath(clipPath);
    canvas.drawPath(shoulderPath, cutoutPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ProfileIconPainter oldDelegate) => oldDelegate.color != color;
}
