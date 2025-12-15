# Сравнение TypeScript и Dart версий

## Обзор портирования

Этот документ показывает, как оригинальный TypeScript/React код был портирован на Dart/Flutter.

## 1. Класс Complex2

### TypeScript (Complex2.ts)
```typescript
export class Complex2 {
  constructor(public real: number, public imag: number) {}
  
  static fromPolar(r: number, phi: number): Complex2 {
    return new Complex2(r * Math.cos(phi), r * Math.sin(phi));
  }
  
  add(x: Complex2): Complex2 {
    this.real += x.real;
    this.imag += x.imag;
    return this;
  }
}
```

### Dart (complex2.dart)
```dart
class Complex2 {
  double real;
  double imag;

  Complex2(this.real, this.imag);
  
  static Complex2 fromPolar(double r, double phi) {
    return Complex2(r * cos(phi), r * sin(phi));
  }
  
  Complex2 add(Complex2 x) {
    real += x.real;
    imag += x.imag;
    return this;
  }
}
```

**Отличия:**
- В Dart нет модификатора `public` (все публично по умолчанию)
- `Math.cos` → `cos` (прямой импорт из `dart:math`)
- Явное указание типов `double` вместо `number`

## 2. Типы и перечисления

### TypeScript (types.ts)
```typescript
export enum VertexColor {
  Red = 0,
  Blue,
}

export type Vertex = [
  Color: VertexColor,
  A: Complex2,
  B: Complex2,
  C: Complex2
];

export interface IDrawOptions {
  numSubdivisions: number;
  numRays: number;
  wheelRadius: number;
}
```

### Dart (types.dart)
```dart
enum VertexColor {
  red,
  blue,
}

class Vertex {
  final VertexColor color;
  final Complex2 a;
  final Complex2 b;
  final Complex2 c;

  Vertex(this.color, this.a, this.b, this.c);
}

class DrawOptions {
  final int numSubdivisions;
  final int numRays;
  final double wheelRadius;

  DrawOptions({
    required this.numSubdivisions,
    required this.numRays,
    required this.wheelRadius,
  });

  DrawOptions copyWith({...}) {...}
}
```

**Отличия:**
- Tuple типы TypeScript → полноценные классы в Dart
- Interface → class с именованными параметрами
- Добавлен метод `copyWith` для иммутабельных обновлений
- camelCase в TypeScript → lowerCamelCase в Dart для enum значений

## 3. Алгоритм Penrose Tiles

### TypeScript (PenroseTiles.ts)
```typescript
export function subdivide(triangles: Vertexes): Vertexes {
  const result: Vertexes = [];
  for (const [color, A, B, C] of triangles) {
    if (color === VertexColor.Red) {
      const P = subdividePoint(A, B);
      result.push([VertexColor.Red, C, P, B]);
      result.push([VertexColor.Blue, P, C, A]);
    }
    // ...
  }
  return result;
}
```

### Dart (penrose_tiles.dart)
```dart
List<Vertex> subdivide(List<Vertex> triangles) {
  final result = <Vertex>[];
  for (final vertex in triangles) {
    final color = vertex.color;
    final a = vertex.a;
    final b = vertex.b;
    final c = vertex.c;
    
    if (color == VertexColor.red) {
      final p = subdividePoint(a, b);
      result.add(Vertex(VertexColor.red, c, p, b));
      result.add(Vertex(VertexColor.blue, p, c, a));
    }
    // ...
  }
  return result;
}
```

**Отличия:**
- Деструктуризация кортежей → обращение к полям объекта
- `push` → `add`
- `===` → `==`
- Явные типы коллекций: `<Vertex>[]`

## 4. Рисование на Canvas

### TypeScript (PenroseTiles.ts)
```typescript
export function drawPenroseTiles(
  ctx: CanvasRenderingContext2D,
  numSubdivisions: number,
  raysCount: number
): void {
  ctx.save();
  ctx.translate(width / 2.0, height / 2.0);
  ctx.scale(wheelRadius, wheelRadius);
  
  ctx.fillStyle = "rgb(255, 89, 89)";
  ctx.beginPath();
  ctx.moveTo(A.real, A.imag);
  ctx.lineTo(B.real, B.imag);
  ctx.fill();
  
  ctx.restore();
}
```

### Dart (penrose_tiles.dart)
```dart
void drawPenroseTiles(
  Canvas canvas,
  int numSubdivisions,
  int raysCount,
  double wheelRadius,
  Size canvasSize,
) {
  canvas.save();
  canvas.translate(canvasSize.width / 2.0, canvasSize.height / 2.0);
  canvas.scale(wheelRadius, wheelRadius);
  
  final redPaint = Paint()
    ..color = const Color(0xFFFF5959)
    ..style = PaintingStyle.fill;
  
  final path = Path()
    ..moveTo(a.real, a.imag)
    ..lineTo(b.real, b.imag)
    ..close();
  canvas.drawPath(path, redPaint);
  
  canvas.restore();
}
```

**Отличия:**
- `CanvasRenderingContext2D` → `Canvas`
- Стили через объект `Paint` вместо свойств контекста
- `Path` объект вместо последовательных вызовов методов
- Cascade notation `..` для цепочки вызовов

## 5. React компоненты → Flutter виджеты

### TypeScript/React (OptionsFrame.tsx)
```typescript
export const OptionsFrame: FC<OptionsFrameProps> = ({ options, onChange }) => {
  const onChangeNumSubdivisions = (event: Event) => {
    const target = event.target as HTMLInputElement;
    onChange({ ...options, numSubdivisions: parseInt(target.value) });
  };

  return (
    <section class="parameters-section">
      <h1>Parameters</h1>
      <label>
        <input
          type="range"
          min="0"
          max="9"
          value={options.numSubdivisions}
          onChange={onChangeNumSubdivisions}
        />
        Subdivisions {options.numSubdivisions}
      </label>
    </section>
  );
};
```

### Dart/Flutter (options_frame.dart)
```dart
class OptionsFrame extends StatelessWidget {
  final DrawOptions options;
  final ValueChanged<DrawOptions> onChanged;

  const OptionsFrame({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const Text('Parameters', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Slider(
              value: options.numSubdivisions.toDouble(),
              min: 0,
              max: 9,
              onChanged: (value) {
                onChanged(options.copyWith(
                  numSubdivisions: value.toInt(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Отличия:**
- Functional Component → StatelessWidget
- JSX → Flutter widget tree
- HTML элементы (`<section>`, `<label>`) → Flutter виджеты (`Container`, `Column`)
- CSS классы → inline стили через Flutter свойства
- Object spread `{...options}` → метод `copyWith()`

## 6. Главное приложение

### TypeScript/React (index.tsx)
```typescript
const App: FC = () => {
  const [options, setOptions] = useState<IDrawOptions>(...);
  const canvasRef = useRef(null);
  
  useEffect(function draw() {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");
    drawPenroseTiles(ctx, ...);
  }, [options]);
  
  return (
    <>
      <canvas ref={canvasRef} />
      <OptionsFrame options={options} onChange={setOptions} />
    </>
  );
};
```

### Dart/Flutter (main.dart)
```dart
class _PenroseTilesHomePageState extends State<PenroseTilesHomePage> {
  late DrawOptions options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: PenroseTilesPainter(options),
            size: Size.infinite,
          ),
          OptionsFrame(
            options: options,
            onChanged: (newOptions) {
              setState(() {
                options = newOptions;
              });
            },
          ),
        ],
      ),
    );
  }
}
```

**Отличия:**
- `useState` → `State` класс с полем и `setState`
- `useEffect` → `CustomPainter` с автоматической перерисовкой
- `useRef` → не нужен, Canvas управляется Flutter
- Fragment `<>` → `Stack` виджет
- `<canvas>` → `CustomPaint`

## Архитектурные отличия

### TypeScript/React подход:
- Императивное рисование на canvas
- Эффекты для управления жизненным циклом
- Хуки для состояния
- CSS для стилизации

### Dart/Flutter подход:
- Декларативный UI
- CustomPainter для рисования
- State management через StatefulWidget
- Виджеты для layout и стилей
- Автоматическая перерисовка при изменении состояния

## Производительность

Flutter версия обладает следующими преимуществами:
- Нативная компиляция (для mobile/desktop)
- Аппаратное ускорение Skia
- Оптимизированная перерисовка через shouldRepaint
- Поддержка всех платформ из единого кодбейса
