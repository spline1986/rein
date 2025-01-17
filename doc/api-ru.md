# Общая информация

По умолчанию: 256x256, 16 цветов палитры pico8, возможность работы с rgba сохранена.
data/core/core.lua -- микроядро. здесь доступны все функции платформы.
data/core/api.lua -- пример реализации конкретного api.

# Переменные

- AGGS -- массив с аргументами. Первый - путь к выполняемому скрипту;
- DATADIR -- путь к каталогу data/ rein;
- VERSION -- версия rein (строка);

# Цвет

Цвета могут задаваться в виде rgba, например:

{ 127, 127, 0, 255 }

Или в виде индекса в палитре. Палитра может содержать 256 цветов (0..255). -1 -- прозрачный { 0, 0, 0, 0 }

# data/core/api.lua

Это тот файл, который настраивает среду исполнения вашей игры.

# gfx

- gfx.pal(число, цвет) -- установить цвет палитры

local r, g, b, a = gfx.pal(цвет) -- взять цвет и вернуть r, g, b, a

- gfx.new(w, h) -- создать объект с пикселями wxh
- gfx.new(файл) -- создать объект с пикселями из файла (.png, .spr)
- gfx.icon(пиксели) -- сменить иконку приложения
- gfx.win(w, h) -- изменить разрешение экрана
- gfx.win(пиксели) -- заменить экран на другой (вернёт старый экран)
- gfx.font(файл) -- загрузить шрифт (.ttf или .fnt)
- gfx.flip(время) -- отрисовать окно и поддерживать заданный fps, например:
- gfx.flip(1/50) -- держим частоту 50Hz
- gfx.border(цвет) -- задать цвет бордюра
- gfx.fg(цвет) -- цвет по умолчанию для системных нужд (gfx.print)
- gfx.bg(цвет) -- цвет по умолчанию для системных нужд (gfx.print)
- gfx.loadmap(текст или файл) -- чтение карты спрайтов
- gfx.spr(спрайты, nr, [w, [h, [flipx, [flipy]]]]) -- рисование спрайта из атласа спрайтов по 8x8

Экран представлен объектом с пикселями screen. Например: screen:clear(15)

# методы пикселей

Данные методы могут выполняться на любых пикселях. Например, на экране или изображениях,
загруженных gfx.new.

- :val(x, y) -- получить значения r, g, b, a
- :val(x, y, цвет) -- установить цвет
- :clip(x1, y1, x2, y2) -- установить границы рисования
- :noclip() -- убрать границы рисования
- :offset(xoff, yoff) -- установить смещение рисования (при рисовании в этот объект к координатам добавятся xoff, yoff)
- :nooffset() -- установить смещение рисования в 0, 0
- :pixel(x, y, цвет) -- нарисовать пиксель (с учётом альфы)
- :buff(таблица с числами, [x, y, w, h]) -- быстрое заполнение буфера с пикселями из таблицы. Значение таблицы:

```
r*0x1000000 + g*0x10000 + b*0x100 + a
```

- :buff() -- получить буфер с пикселями
- :size() -- получить w и h
- :fill([x, y, w, h,] цвет) -- заливка цветом
- :fill([x, y, w, h,] пиксели) -- заливка пикселями
- :clear -- как fill но просто затирание одного цвета другим, без учёта прозрачности. Быстрее.
- :copy([fx, fy, fw, fh, ]пиксели, [x, y]) -- копирование пикселей из одного объекта в другой
- :blend -- как copy но с учётом прозрачности
- :line(x1, y1, x2, y2, цвет) -- линия
- :line(x1, y1, x2, y2, пиксели) -- линия по трафарету
- :lineAA -- как line, но с AA
- :fill_triangle(x1, y1, x2, y2, x3, y3, цвет или пиксели) -- заливка треугольника
- :circle(xc, yc, r) -- окружность
- :circle(xc, yc, пиксели) -- окружность по трафарету
- :circleAA -- как circle, но с AA
- :fill_circle(xc, yc, r, цвет или пиксели) -- заливка круга
- :fill_poly({вершины}, цвет) -- заливка полигона
- :fill_rect(x1, y1, x2, y2, цвет) -- заливка прямоугольника
- :fill_rect(x1, y1, x2, y2, пиксели) -- заливка прямоугольника пикселями
- :poly({вершины}, цвет) -- полигон
- :poly({вершины}, пиксели) -- полигон по трафарету
- :polyAA -- как poly, но с AA
- :rect(x1, y1, x2, y2, цвет) -- прямоугольник
- :rect(x1, y1, x2, y2, пиксели) -- прямоугольник по трафарету
- :rectAA -- как rect, но с AA
- :scale(xs, ys, smooth) -- вернёт новые пиксели после масштабирования
- :flip(h, v) -- создать отображённый по горизонтали и/или вертикали спрайт (быстрее scale)
- :stretch(пиксели, x, y, w, h) -- растянуть или сжать изображение и поместить его в пиксели в указанную область. быстрее scale

# методы шрифта

Системный шрифт доступен как font. Вы не можете его менять, но можете загружать другие шрифты и использовать их.

- :size(текст) -- рассчитать ширину и высоту текста без рендеринга
- :text(текст, цвет) -- создать пиксели с отрендеренным текстом

Вам доступна функция gfx.print. Она рисует текст в screen и может переносить слова при
выходе за границу окна.

```
gfx.print("текст", [x, y, цвет, переносить ли слова])
gfx.printf(x, y, цвет, "форматная строка", ...)
```

# sys

sys.input() -- возвращает события ввода. первое значение - тип события, остальные - аргументы.

Типы: mousedown, mouseup, mousemotion, keydown, keyup, mousewheel, quit...

- sys.time() -- время в секундах после запуска игры
- sys.title(текст) -- задать заголовок окна
- sys.log(строка) -- записать в лог
- sys.readdir(путь) -- прочитать содержимое каталога
- sys.chdir(путь) -- сменить каталог
- sys.mkdir(путь) -- создать каталог
- sys.sleep(секунд) -- сон
- sys.go(функция) -- создать корутину и запустить в рамках core (планировать не надо), вернёт корутину
- sys.stop(корутина) -- остановить и убрать из списка планируемых
- sys.yield() -- синоним coroutine.yiled()
- sys.newrand([зерно]) -- создать экземпляр датчика случайных чисел
- sys.clipboard([текст]) -- получить или установить текст в буффере обмена

метод датчика случайных чисел: rnd([старт,[конец]])

```
main = sys.newrand(12345)
main:rnd() -- повторяемая цепочка чисел от 0 до 1.0
main:rnd(1, 5) -- от 1 до 5
main:rnd(3) -- от 1 до 3
```

# input

input.mouse() вернёт x, y и mb таблицу состояния кнопок.
local x, y, mb = input.mouse()
if mb.left then...

- input.keydown(клавиша) -- вернёт true если клавиша нажата.
- input.keypress(клавиша) -- как keydown, но сработает один раз (до следующего нажатия).

# thread

- thread.start(функция) -- запустить поток (вернёт объект - поток)

методы потоков:

- :wait() -- ждать завершения
- :read() -- прочитать данные
- :write() -- передать данные

В качестве данных можно передавать примитивные типы lua и пиксели.

# net

- net.dial(хост, порт) -- создать tcp соединение и вернуть неблокирующий сокет
- :send(строка, [смещение,[длина]])
- :recv()
- :close()

# utf

Работа с utf строками.

utf.new("текст")

- :sub(s, e)
- :iter()
- :len()

# bit

Битовые операции (luabitops)

# mixer

Пока в работе. Внутри использует не проброшенную system.audio(буфер).

# Остальное

table, math, string, pairs, ipairs, io, tonumber, tostring, coroutine -- проброшены "как есть".
dump -- пока не проброшено (сериализация структур данных lua).

error(ошибка) -- упасть по ошибке

# Форматы

Кроме привычных ttf/png поддерживаются свои простые текстовые форматы, которые удобно встраивать прямо в код. Например:

```
local s = gfx.new [[
--*
-*-*-*
*-*-*-
-*-*-*
*-*-*-
]]
```

В данном случае создастся изображение 6x3. Состоящее из "сеточки" цвета с индексом 2.

Вы можете сделать screen:fill(s) и посмотреть, что будет :)

1я строка текста - соответствия символов ascii в цвета палитры.
Например: --* означает, что символом * кодируется цвет 2.
0123456789abcdef -- все 16 цветов кодируются символами от 0 до f
Далее идут строки с изображением. - -- прозрачный. Остальные символы соответствуют кодированию палитры.

Формат шрифтов можно посмотреть открыв файл data/fonts/8x8.fnt
