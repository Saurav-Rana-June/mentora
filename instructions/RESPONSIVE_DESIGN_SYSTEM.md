# 📐 Universal Responsive Design System for Flutter Web & Apps
### *Concept, Architecture, Methodologies & Implementation Blueprint*

---

## 📑 Table of Contents
1. [Executive Overview & Philosophy](#1-executive-overview--philosophy)
2. [The 4-Layer Hybrid Responsive Architecture](#2-the-4-layer-hybrid-responsive-architecture)
3. [The Core Breakpoint & Scaling Engine (`AppScale`)](#3-the-core-breakpoint--scaling-engine-appscale)
4. [Responsive Layout Reflow Patterns](#4-responsive-layout-reflow-patterns)
   - [Pattern A: Maximum Width Centering](#pattern-a-maximum-width-centering)
   - [Pattern B: Split Direction Reflow (Row ↔ Column)](#pattern-b-split-direction-reflow-row--column)
   - [Pattern C: Adaptive Responsive Grids](#pattern-c-adaptive-responsive-grids)
   - [Pattern D: Fluid Wrap & Tag Clouds](#pattern-d-fluid-wrap--tag-clouds)
   - [Pattern E: Responsive Modals & Dialogs](#pattern-e-responsive-modals--dialogs)
   - [Pattern F: Adaptive Navigation (Desktop Rail ↔ Mobile Drawer/Menu)](#pattern-f-adaptive-navigation-desktop-rail--mobile-drawermenu)
5. [Step-by-Step Implementation Guide for Any Project](#5-step-by-step-implementation-guide-for-any-project)
6. [Complete Ready-to-Use Code Blueprints](#6-complete-ready-to-use-code-blueprints)
7. [Mathematical Formulas & Typography Clamping](#7-mathematical-formulas--typography-clamping)
8. [Best Practices & Common Pitfalls Checklist](#8-best-practices--common-pitfalls-checklist)

---

## 1. Executive Overview & Philosophy

Building responsive web applications in Flutter presents unique challenges compared to standard mobile apps:
- **Continuous Viewport Resizing**: Desktop browser windows can be resized arbitrarily to any width and height in real time.
- **Extreme Display Disparities**: A single codebase must render cleanly on a 320px mobile screen, a 768px tablet, a 1440px laptop, and a 3840px (4K) ultrawide monitor.
- **Text & Density Disconnect**: Naive scaling (scaling everything linearly based on screen width) makes mobile text illegibly small and desktop text comically gigantic.

### 💡 The Solution: The Hybrid Adaptive Architecture
Instead of choosing between **pure dynamic scaling** (`flutter_screenutil`) or **hard breakpoints** (`LayoutBuilder` / `MediaQuery`), this architecture combines both into a unified system:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        VIEWPORT & BROWSER RESIZE                       │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Layer 1: Base Canvas & Lifecycle (ScreenUtilInit + MediaQuery Binding) │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Layer 2: Centralized Scaling Engine (AppScale - Dampened & Clamped)    │
│  - Breakpoints: Mobile (<600) | Tablet (600-1024) | Desktop (>1024)   │
│  - Linear Interpolation (lerp) for smooth typography & icons          │
│  - Dampened dimensional scaling (w, h, r)                             │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Layer 3: Content Bounding & Spacing (ConstrainedBox + MaxWidth)        │
│  - Prevents 4K stretching (Max content width: 1200px)                  │
│  - Responsive vertical & horizontal page gutters                       │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Layer 4: Structural Layout Reflow (Widgets & Composition)              │
│  - Row ↔ Column switching                                              │
│  - Dynamic GridView crossAxisCount & AspectRatio                       │
│  - Fluid Wrap chips & LayoutBuilder width-clamping                     │
│  - Adaptive Navigation (Pill Nav ↔ Glass Bottom Sheet / Drawer)        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. The 4-Layer Hybrid Responsive Architecture

### Layer 1: Base Canvas & Lifecycle Initialization
- Standardizes design units to a reference design canvas (e.g. `1440 x 1024` for desktop-first web).
- Configures `ScreenUtilInit` with `minTextAdapt: true` and `rebuildFactor: RebuildFactors.change` so that dynamic window resizing triggers layout rebuilds instantly.
- Registers `MediaQuery.of(context)` at root page screens to maintain active listeners on window resize.

### Layer 2: The `AppScale` Central Engine
- Serves as the single source of truth for breakpoints, typography sizes, spacing, and icon scales.
- Uses **dampened interpolation**: Rather than scaling by raw screen width (which breaks layouts at extreme resolutions), it clamps scaling factors to comfortable human-readable ranges.

### Layer 3: Max-Width Content Bounding
- Every section is wrapped in `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth())))`.
- On mobile devices, `contentMaxWidth()` evaluates to the screen width.
- On large desktop monitors, it caps at `1200px`, creating a neat, centered aesthetic with balanced margins.

### Layer 4: Structural Reflow Widgets
- **Row ↔ Column Switching**: Side-by-side elements on desktop reflow into vertical stacks on tablet/mobile.
- **Dynamic Grid Columns**: Grids transition automatically from 3 columns (desktop) to 2 columns (tablet) to 1 column (mobile).
- **Fluid Wrapping**: Tag clouds and skill badges dynamically wrap to the next line using `Wrap(spacing: ..., runSpacing: ...)`.

---

## 3. The Core Breakpoint & Scaling Engine (`AppScale`)

The core engine is encapsulated in `lib/infrastructure/theme/app_scale.dart`.

### 3.1 Breakpoint Thresholds

| Device Tier | Screen Width Range | Usage Context |
| :--- | :--- | :--- |
| **Mobile** | `< 600 px` | Single-column layout, full width, stacked elements, hamburger menu |
| **Tablet** | `600 px - 1024 px` | 2-column grids, hybrid flex ratios, condensed navigation |
| **Desktop** | `> 1024 px` | Full multi-column split views, expanded navbar, fixed max content bounds (1200px) |

### 3.2 Typography Interpolation Math
Linear interpolation prevents abrupt text popping when resizing windows. Inside mobile (`320px` to `600px`), the text factor smoothly interpolates between `0.90` and `0.96`:

```dart
// t: Normalized progress between min and max device width
final double t = (screenWidth - minWidth) / (maxWidth - minWidth);

// adaptedScale: Clamped linear interpolation (lerp)
final double adaptedScale = (minScale + t * (maxScale - minScale)).clamp(minScale, maxScale);
```

### 3.3 Dimension Dampening (`w`, `h`, `r`)
If a desktop button is `48px`, naively scaling it on a 360px mobile screen with `48 * (360/1440)` would yield an unusable `12px` button.
`AppScale.w()` applies a **dampened scale multiplier** so dimensions adapt gracefully without shrinking beyond usability:

- **Desktop**: `scale` (1.0)
- **Tablet**: `0.85` to `1.0`
- **Mobile**: `0.65` to `0.85`

---

## 4. Responsive Layout Reflow Patterns

### Pattern A: Maximum Width Centering
Prevents content from sprawling unreadably across wide 2K/4K monitors.

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: AppScale.pagePaddingHorizontal(),
    vertical: AppScale.sectionPaddingVertical(),
  ),
  child: Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
      child: Column(
        children: [
          // Section header and body content
        ],
      ),
    ),
  ),
)
```

---

### Pattern B: Split Direction Reflow (Row ↔ Column)
Used in Hero sections, About sections, and Contact forms.

```dart
final bool showRow = AppScale.isDesktop; // Or (!AppScale.isMobile && !AppScale.isTablet)

showRow
    ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildLeftContent()),
          AppScale.w(24).gapW,
          Expanded(flex: 2, child: _buildRightContent()),
        ],
      )
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeftContent(),
          AppScale.h(32).gapH,
          _buildRightContent(),
        ],
      );
```

---

### Pattern C: Adaptive Responsive Grids
Projects and card grids dynamically adjust both column count and aspect ratio per breakpoint.

```dart
final int crossAxisCount = AppScale.isDesktop
    ? 3
    : AppScale.isTablet
        ? 2
        : 1;

final double aspectRatio = AppScale.isMobile
    ? 1.5
    : AppScale.isTablet
        ? 1.3
        : 1.1;

GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    crossAxisSpacing: AppScale.w(16),
    mainAxisSpacing: AppScale.h(16),
    childAspectRatio: aspectRatio,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ProjectCard(project: items[index]),
);
```

---

### Pattern D: Fluid Wrap & Tag Clouds
Used for skills, tags, tech badges, and category filters. Ensures chips naturally wrap across lines without horizontal clipping.

```dart
Wrap(
  spacing: 12,      // Horizontal gap between items
  runSpacing: 12,   // Vertical gap between wrapped rows
  alignment: WrapAlignment.center,
  children: skills.map((skill) => SkillChip(skill: skill)).toList(),
)
```

---

### Pattern E: Responsive Modals & Dialogs
Ensures dialogs never clip outside the viewport or take full screen on desktop.

```dart
Center(
  child: Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppScale.pagePaddingHorizontal(),
      vertical: AppScale.h(24),
    ),
    constraints: BoxConstraints(
      maxWidth: AppScale.isMobile ? double.infinity : 700,
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DialogContent(),
    ),
  ),
)
```

---

### Pattern F: Adaptive Navigation (Desktop Rail ↔ Mobile Drawer/Menu)
Switches between full horizontal links on desktop and a compact hamburger popup on mobile/tablet.

```dart
final bool isCompact = !AppScale.isDesktop;

Row(
  children: [
    _BrandLogo(showSubtitle: !isCompact),
    const Spacer(),
    if (!isCompact)
      _DesktopNavigationLinks(items: navItems, onSelected: onNavigate)
    else
      _MobileHamburgerMenuButton(items: navItems, onSelected: onNavigate),
  ],
)
```

---

## 5. Step-by-Step Implementation Guide for Any Project

Follow these 6 steps to implement this responsive architecture in any Flutter project:

### Step 1: Add Dependencies
Add `flutter_screenutil` to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_screenutil: ^5.9.3
```

---

### Step 2: Initialize in `main.dart`
Configure `ScreenUtilInit` at the root of your widget tree:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design canvas matching your Figma desktop design
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.change, // Vital for web browser resizing!
      builder: (context, child) {
        return MaterialApp(
          title: 'My Responsive App',
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
```

---

### Step 3: Add the `AppScale` Engine
Create `lib/infrastructure/theme/app_scale.dart` (copy from Section 6).

---

### Step 4: Add Spacing Utility Extension
Create `lib/data/extensions/spacing.dart` for clean and readable layout spacing:

```dart
import 'package:flutter/material.dart';

class Spacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
}

extension SpacingBox on double {
  Widget get gapH => SizedBox(height: this);
  Widget get gapW => SizedBox(width: this);
}
```

---

### Step 5: Register `MediaQuery` in Root Screens
Ensure screen widgets register `MediaQuery.of(context)` at the top of `build()` to trigger rebuilds on window dimension change:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Registers media query listener for browser resize triggers
    MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HeroSection()),
          SliverToBoxAdapter(child: AboutSection()),
          SliverToBoxAdapter(child: ProjectsSection()),
          SliverToBoxAdapter(child: ContactSection()),
        ],
      ),
    );
  }
}
```

---

### Step 6: Build Sections Using the Standard Template
Apply the Max-Width Centering and Split Direction Reflow patterns to every section.

---

## 6. Complete Ready-to-Use Code Blueprints

### 📁 Blueprint 1: `app_scale.dart` (Production-Ready)

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized breakpoint-aware scaling engine for Flutter Web and Mobile.
abstract final class AppScale {
  static double get _width => ScreenUtil().screenWidth;

  // ---------------------------------------------------------------------------
  // Breakpoint Gates
  // ---------------------------------------------------------------------------
  static bool get isMobile => _width < 600;
  static bool get isTablet => _width >= 600 && _width <= 1024;
  static bool get isDesktop => _width > 1024;

  // ---------------------------------------------------------------------------
  // Typography Scaling (Clamped & Continuous Interpolation)
  // ---------------------------------------------------------------------------
  static double font(double size) {
    if (isMobile) {
      final double scale = ScreenUtil().scaleText;
      final double t = (_width - 320) / (600 - 320);
      final double adaptedScale = (0.90 + t * (0.96 - 0.90)).clamp(0.90, 0.96);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else if (isTablet) {
      final double scale = ScreenUtil().scaleText;
      final double t = (_width - 600) / (1024 - 600);
      final double adaptedScale = (0.96 + t * (1.00 - 0.96)).clamp(0.96, 1.00);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else {
      // Desktop / Web scaling clamped between 1.0x and 1.12x
      return size * (_width / 1440).clamp(1.0, 1.12);
    }
  }

  // Pre-configured text scale shortcuts
  static double displayLarge() => font(48);
  static double displayMedium() => font(32);
  static double headline() => font(24);
  static double title() => font(18);
  static double body() => font(14);
  static double caption() => font(12);

  // ---------------------------------------------------------------------------
  // Icon Scaling
  // ---------------------------------------------------------------------------
  static double icon(double size) {
    if (isMobile) {
      final double t = (_width - 320) / (600 - 320);
      final double adaptedScale = (0.80 + t * (0.90 - 0.80)).clamp(0.78, 0.95);
      return size * adaptedScale;
    }
    if (isTablet) return size + 2;
    return size * (_width / 1440).clamp(0.95, 1.08);
  }

  // ---------------------------------------------------------------------------
  // Dampened Dimensional Scaling (Width, Height, Radius)
  // ---------------------------------------------------------------------------
  static double w(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      final t = (_width - 600) / (1024 - 600);
      adaptedScale = 0.85 + t * (1.0 - 0.85);
    } else {
      final t = (_width - 320) / (600 - 320);
      adaptedScale = (0.65 + t * (0.85 - 0.65)).clamp(0.65, 0.90);
    }
    return ScreenUtil().setWidth(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double h(double size) {
    final double scale = ScreenUtil().scaleHeight;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      final t = (_width - 600) / (1024 - 600);
      adaptedScale = 0.80 + t * (0.95 - 0.80);
    } else {
      final t = (_width - 320) / (600 - 320);
      adaptedScale = (0.60 + t * (0.80 - 0.60)).clamp(0.60, 0.85);
    }
    return ScreenUtil().setHeight(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double r(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale.clamp(0.9, 1.0);
    } else if (isTablet) {
      adaptedScale = 0.9;
    } else {
      adaptedScale = 0.8;
    }
    return ScreenUtil().radius(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  // ---------------------------------------------------------------------------
  // Universal Layout Spacing & Max Bounds
  // ---------------------------------------------------------------------------
  static double pagePaddingHorizontal() {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 24;
  }

  static double sectionPaddingVertical() {
    if (isMobile) return 36;
    if (isTablet) return 42;
    return 48;
  }

  static double heroPaddingVertical() {
    if (isMobile) return 48;
    if (isTablet) return 64;
    return 80;
  }

  static double contentMaxWidth() {
    if (isMobile) return _width;
    if (isTablet) return 920;
    return 1200;
  }

  static double navTopSpacer() {
    if (isMobile) return 92;
    return 96;
  }
}
```

---

### 📁 Blueprint 2: Reusable Responsive Section Template

```dart
import 'package:flutter/material.dart';
import 'app_scale.dart';
import 'spacing.dart';

class ResponsiveSectionTemplate extends StatelessWidget {
  const ResponsiveSectionTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showRow = AppScale.isDesktop;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section Header
              Text(
                'SECTION SUBTITLE',
                style: TextStyle(
                  fontSize: AppScale.font(12),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Main Section Title',
                style: TextStyle(
                  fontSize: AppScale.displayMedium(),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'A brief overview explaining this section content.',
                style: TextStyle(
                  fontSize: AppScale.font(14),
                  color: Colors.grey,
                ),
              ),
              AppScale.h(48).gapH,

              // Adaptive Split Content
              showRow
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildLeftCard()),
                        AppScale.w(24).gapW,
                        Expanded(flex: 2, child: _buildRightCard()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeftCard(),
                        AppScale.h(24).gapH,
                        _buildRightCard(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftCard() {
    return Container(
      padding: EdgeInsets.all(AppScale.w(24)),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppScale.r(16)),
      ),
      child: Text(
        'Left Panel Content',
        style: TextStyle(fontSize: AppScale.font(15)),
      ),
    );
  }

  Widget _buildRightCard() {
    return Container(
      padding: EdgeInsets.all(AppScale.w(24)),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppScale.r(16)),
      ),
      child: Text(
        'Right Panel Content',
        style: TextStyle(fontSize: AppScale.font(15)),
      ),
    );
  }
}
```

---

## 7. Mathematical Formulas & Typography Clamping

### Why Clamping is Essential
If scaling is linear with no bounds:
$$\text{Scaled Size} = \text{Base Size} \times \frac{\text{Viewport Width}}{1440}$$

On a 3840px 4K monitor:
$$\text{Font Size} = 16 \times \frac{3840}{1440} = 42.6\text{px}$$
*Result: Body text looks like an oversized billboard.*

### The Clamped Interpolation Formula
This architecture uses normalized linear interpolation with clamping:

$$t = \frac{W - W_{\min}}{W_{\max} - W_{\min}}$$

$$\text{Scale}_{\text{adapted}} = \text{clamp}\left(S_{\min} + t \cdot (S_{\max} - S_{\min}),\; S_{\min},\; S_{\max}\right)$$

```
Mobile (320px -> 600px):    Scale smoothly adapts from 0.90 to 0.96
Tablet (600px -> 1024px):   Scale smoothly adapts from 0.96 to 1.00
Desktop (1024px -> 3840px): Scale clamped strictly between 1.00 and 1.12
```

---

## 8. Best Practices & Common Pitfalls Checklist

### ✅ Do:
1. **Always bound wide screen widths**: Wrap section bodies inside `ConstrainedBox(maxWidth: AppScale.contentMaxWidth())`.
2. **Use `Wrap` for dynamic item lists**: Use `Wrap` instead of horizontal `Row` when rendering tags, badges, or button groups that might overflow on small viewports.
3. **Use `gapW` and `gapH`**: Replace hardcoded `SizedBox` with the `SpacingBox` extension for clean, readable spacing.
4. **Test in browser with real-time resizing**: Drag your browser window from 320px up to full monitor width to verify transitions.
5. **Set `rebuildFactor: RebuildFactors.change`**: In `ScreenUtilInit` so Flutter rebuilds on every window dimension delta.

### ❌ Don't:
1. **Never use hardcoded pixel widths for full sections**: Avoid `width: 1200` without wrapping in `ConstrainedBox` or checking screen width.
2. **Never scale fonts with pure raw multiplication**: Always use `AppScale.font(size)` to prevent unreadable text on mobile or gigantic text on 4K.
3. **Avoid fixed heights on text containers**: Let text wrap naturally; avoid hardcoded `height: 50` on card bodies where translated or wrapped text might overflow.
4. **Don't hardcode grid cross-axis counts**: Use `AppScale.isDesktop ? 3 : AppScale.isTablet ? 2 : 1`.
5. **Avoid horizontal overflow on mobile**: Replace side-by-side buttons with full-width stacked buttons or `Wrap` on mobile.

---

### 🎯 Summary Architecture Cheat Sheet

```
┌─────────────────────────────────┬──────────────────────────────────────────┐
│ Feature                         │ Implementation Pattern                   │
├─────────────────────────────────┼──────────────────────────────────────────┤
│ Breakpoints                     │ AppScale.isMobile / isTablet / isDesktop │
│ Dynamic Typography              │ AppScale.font(size)                      │
│ Dynamic Dimensions              │ AppScale.w(size) / AppScale.h(size)      │
│ Border Radii                    │ AppScale.r(radius)                       │
│ Max Content Bound               │ AppScale.contentMaxWidth() (1200px cap)  │
│ Section Padding                 │ AppScale.pagePaddingHorizontal() / ...   │
│ Split Reflow                    │ isDesktop ? Row(...) : Column(...)       │
│ Grids                           │ GridView (3 cols -> 2 cols -> 1 col)     │
│ Tags / Badges                   │ Wrap(spacing: 12, runSpacing: 12)        │
│ Modals / Dialogs                │ BoxConstraints(maxWidth: 700, maxH: 85%) │
└─────────────────────────────────┴──────────────────────────────────────────┘
```
