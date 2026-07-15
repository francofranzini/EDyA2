# Contexto EDyA2 — Resumen de Apuntes para Coloquio

> Este archivo condensa los apuntes 01-09 (excluyendo 03-Haskell) de la materia
> Estructuras de Datos y Algoritmos 2. Leer este archivo basta para tener el contexto.

---

## Apunte 01 — Modelo de Costo

### Trabajo y Profundidad
- **Trabajo W**: costo secuencial (1 procesador). W = |E| (total de operaciones).
- **Profundidad S**: costo paralelo (∞ procesadores). S = longitud del camino crítico (máximo camino en el DAG de dependencias).
- **Paralelismo**: P = W/S. Indica cuántos procesadores se pueden usar eficientemente.
- Queremos algoritmos con W del orden del mejor secuencial, y entre esos, el de mayor P.

### Notación asintótica
- **O(g)**: cota superior. ∃ c, n0 tal que 0 ≤ f(n) ≤ c·g(n) ∀n ≥ n0.
- **Ω(g)**: cota inferior. ∃ c, n0 tal que 0 ≤ c·g(n) ≤ f(n) ∀n ≥ n0.
- **Θ(g)**: cota ajustada. f ∈ O(g) y g ∈ O(f).
- Orden de crecimiento: Θ(1) ⊂ Θ(lg n) ⊂ Θ(n) ⊂ Θ(n lg n) ⊂ Θ(n²) ⊂ Θ(2ⁿ) ⊂ Θ(n!).

### Scheduler Voraz (Principio de Brent)
- Un scheduler es voraz si cuando hay un procesador libre y tareas para ejecutar, asigna inmediatamente.
- **Teorema (Brent)**: T < W/p + S, donde p = cantidad de procesadores.
- Si p ≪ P, la cota es prácticamente óptima.

### Modelo de costo basado en lenguaje
- Pares ordinarios `(e1, e2)` y paralelos `(e1 || e2)`.
- `let x = e1 in e2`, secuencias por comprensión `[f x | x ← xs]`.
- **W**: W(c)=1, W(op e)=1+W(e), W(e1,e2)=1+W(e1)+W(e2), W(e1||e2)=1+W(e1)+W(e2), W([f x | x←xs])=1+ΣW(f x).
- **S**: S(c)=1, S(op e)=1+S(e), S(e1,e2)=1+S(e1)+S(e2), S(e1||e2)=1+max(S(e1),S(e2)), S([f x | x←xs])=1+max S(f x).

### Divide & Conquer (general)
- Caso base: resolver directamente. Caso recursivo: dividir, resolver recursivamente, combinar.
- W(n) = W_dividir(n) + Σ W(ni) + W_combinar(n)
- S(n) = S_dividir(n) + max S(ni) + S_combinar(n)

### Mergesort (sobre listas)
- `split` divide en 2 sublistas (O(n) trabajo y profundidad).
- `merge` combina 2 listas ordenadas (O(n) trabajo y profundidad).
- W_msort(n) = 2W_msort(n/2) + cn ∈ **O(n lg n)**
- S_msort(n) = S_msort(n/2) + kn ∈ **O(n)** (¡poco paralelizable! el problema son las listas)

---

## Apunte 02 — Recurrencias

### Método de sustitución
1. Adivinar la forma de la solución.
2. Probar por inducción matemática.
- Se puede sumar/restar términos de menor orden para poder terminar la prueba.

### Árboles de recurrencia
- Se expande la recurrencia en un árbol, se suma el costo por nivel.
- Da un candidato exacto o aproximado para usar con sustitución.
- Ejemplo: T(n)=3T(n/4)+cn² → sumar serie geométrica → O(n²).

### Funciones suaves
- **Eventualmente no decreciente**: ∃N. f(n) ≤ f(n+1) ∀n ≥ N.
- **b-suave**: eventualmente no decreciente y f(bn) ∈ O(f(n)).
- **Suave**: b-suave para todo b ≥ 2. (Basta que lo sea para un b ≥ 2.)
- Ejemplos suaves: n², n^r, n lg n. No suaves: n^(lg n), 2ⁿ, n!.

### Regla de suavidad
- Sea f suave y g eventualmente no decreciente:
  g(b^k) ∈ Θ(f(b^k)) ⇒ g(n) ∈ Θ(f(n))
- Permite resolver recurrencias ignorando ⌊⌋ y ⌈⌉ cuando la solución es suave.

### Teorema Maestro
- Para T(n) = aT(n/b) + f(n), con a≥1, b>1:
  - **Caso 1**: si f(n) ∈ O(n^(log_b a - ε)) → T(n) ∈ Θ(n^(log_b a))
  - **Caso 2**: si f(n) ∈ Θ(n^(log_b a)) → T(n) ∈ Θ(n^(log_b a) lg n)
  - **Caso 3**: si f(n) ∈ Ω(n^(log_b a + ε)) y condición regularidad → T(n) ∈ Θ(f(n))
- Los casos se deciden comparando f(n) con n^(log_b a); debe ser polinomialmente mayor/menor.
- Los tres casos no cubren todas las posibilidades (ej: f(n)=n lg n vs g(n)=n).

---

## Apunte 04 — Tipos en Haskell

### Sinónimos de tipos (type)
- `type String = [Char]` es solo un alias.
- Pueden tener parámetros: `type Par a = (a,a)`.
- Pueden anidarse pero **no ser recursivos**.

### Declaraciones data
- `data Bool = False | True` declara un nuevo tipo con constructores.
- Los constructores empiezan con mayúscula.
- Pueden tener parámetros: `data Shape = Circle Float | Rect Float Float`.
- Los constructores son funciones: `Circle :: Float → Shape`.
- Sintaxis de records: `data Alumno = A { nombre :: String, edad :: Int }`.

### Constructores de tipos
- `data Maybe a = Nothing | Just a`. Maybe tiene kind * → *.
- Maybe se usa para señalizar errores o totalizar funciones parciales.
- `data Either a b = Left a | Right b`. Either corresponde a unión disjunta.
- Either se usa para errores con información (error en Left).

### Tipos recursivos
- `data Nat = Zero | Succ Nat`.
- `data List a = Nil | Cons a (List a)`.
- Árboles: `data T1 a = Tip a | Bin (T1 a) (T1 a)`, `data T2 b = Empty | Branch (T2 b) b (T2 b)`, etc.
- Se pueden llevar medidas en el árbol (weight) para consultar en O(1): `data T a = Tip Weight a | Bin Weight (T a) (T a)` con invariante weight(Bin w t1 t2) = weight t1 + weight t2.
- Constructor inteligente `bin t1 t2 = Bin (weight t1 + weight t2) t1 t2`.

### Codificación de Huffman
- Asigna bits según frecuencia: símbolos frecuentes → secuencias cortas.
- Árbol binario con información en las hojas. Codifica la tabla de códigos.
- Tipo: `data T a = Tip Weight a | Bin Weight (T a) (T a)`.
- **Decodificación**: `trace :: T a → Camino → (a, Camino)` sigue camino hasta hoja; `decodexs` repite.
- **Codificación**: `codex :: Eq t ⇒ T t → t → Camino` busca el camino a una hoja; `codexs` mapea sobre toda la lista.
- **Construcción**: `build :: [(a,Weight)] → T a` toma lista de (símbolo, peso) ordenada, crea hojas, combina las dos más pequeñas repetidamente con `until single combine`.

---

## Apunte 05 — Estructuras Inmutables

### Inmutables vs efímeras
- **Efímeras**: cambios destructivos, una sola versión, modelo secuencial.
- **Inmutables**: soportan varias versiones, fácilmente paralelizables. Los nodos que no cambian se comparten (sharing). El GC es esencial.
- Ejemplo: concatenación de listas inmutables copia todo xs → O(|xs|).

### BSTs (Árboles binarios de búsqueda)
- `data Bin a = Hoja | Nodo (Bin a) a (Bin a)`.
- Invariante:Todo in a subárbol izq tiene un valor <= el subárbol padre; si está en el subárbol derecho entonces es > el valor del subárbol padre.
- **member**: O(h) donde h = altura. Busca en izq o der según comparación.
- **insert**: recorre hasta una hoja, crea nuevo nodo. O(h). Preserva sharing de las ramas no modificadas.
- **delete**: 3 casos — (a) nodo con hojas como subárboles → reemplazar por Hoja; (b) un solo subárbol con datos → reemplazar por ese subárbol; (c) dos subárboles → buscar mínimo del subárbol derecho, reemplazar el nodo por ese mínimo y borrarlo del subárbol derecho.
- En el peor caso h = O(n) (árbol degenerado). Solución: árboles balanceados.

### RBTs (Red-Black Trees)
- `data Color = R | B`, `data RBT a = E | T Color (RBT a) a (RBT a)`.
- **INV1**: ningún nodo rojo tiene hijos rojos.
- **INV2**: todos los caminos raíz→hoja tienen igual cantidad de nodos negros (altura negra).
- Consecuencia: camino más largo ≤ 2 × camino más corto. Altura O(lg n).
- **member**: igual que BST, ignora color. O(lg n).
- **insert**: inserta nodo rojo (preserva INV2), puede violar INV1.
  - `insert x t = makeBlack (ins x t)` donde `ins` inserta recursivamente y llama a `balance`.
  - `makeBlack` colorea la raíz de negro.
- **balance**: la violación INV1 ocurre en camino B-R-R. 4 configuraciones posibles. En todas: reescribir como padre rojo con dos hijos negros. O(1) por llamada.
  - `balance B (T R (T R a x b) y c) z d = T R (T B a x b) y (T B c z d)` (y 3 variantes rotadas)
  - `balance c l a r = T c l a r` (caso sin violación)
- W_balance ∈ O(1), W_insert ∈ O(lg n). Implementación simple e inmutable.

### Leftist Heap
- **Rango**: longitud de la espina derecha (camino a la derecha hasta nodo vacío).
- **Invariante leftist**: rango del hijo izquierdo ≥ rango del hijo derecho.
- Consecuencias: la espina derecha es el camino más corto a vacío; longitud ≤ lg(n+1); los elementos de la espina derecha están ordenados.
- `type Rank = Int`, `data Heap a = E | N Rank a (Heap a) (Heap a)`.
- **merge**: O(lg n). Mezcla las espinas derechas ordenadas.
  - `merge h1@(N x a1 b1) h2@(N y a2 b2) = if x ≤ y then makeH x a1 (merge b1 h2) else makeH y a2 (merge h1 b2)`
- **makeH**: preserva invariante leftist, intercambia hijos si hace falta. O(1).
  - `makeH x a b = if rank a ≥ rank b then N (rank b + 1) x a b else N (rank a + 1) x b a`
- **insert**: merge con un nodo singleton. O(lg n).
- **findMin**: devuelve raíz. O(1).
- **deleteMin**: merge de los dos hijos. O(lg n).

---

## Apunte 06 — TADs

### Qué es un TAD
- Un Tipo Abstracto de Datos abstrae detalles de implementación.
- Consta de: (1) nombre de tipo, (2) operaciones, (3) especificación del comportamiento.
- **Usuario**: solo usa la abstracción, supone el comportamiento descripto.
- **Implementador**: provee implementación que se ajusta al comportamiento.

### Especificación algebraica
- Describe operaciones y ecuaciones entre operaciones.
- Solo deben aparecer operaciones del TAD y variables libres (cuantificadas universalmente).
- Ejemplo (Cola): `esVacia vacia = True`, `primero (poner x vacia) = x`, `sacar (poner x (poner y q)) = poner x (sacar (poner y q))`.
- Puede quedar comportamiento sin definir (ej: `primero vacia`).

### Especificación por modelos
- Se elige un modelo matemático (ej: secuencias) y se da función equivalente por cada operación.
- `vacia = ⟨⟩`, `poner x ⟨x₁..xₙ⟩ = ⟨x,x₁..xₙ⟩`, `sacar ⟨x₁..xₙ⟩ = ⟨x₁..xₙ₋₁⟩`.
- Implementación se ajusta al modelo si: ⟦op c⟧ = ⟦op⟧ ⟦c⟧.

### Implementación de colas con par de listas
- `type Cola a = ([a], [a])`. Elementos en orden: xs ++ reverse ys.
- Invariante: si xs es vacía, ys también.
- `validar (xs, ys) = if null xs then (reverse ys, []) else (xs, ys)`.
- Costos: W_vacia=O(1), W_poner=O(1), W_primero=O(1), W_sacar=O(|ys|) pero **O(1) amortizado**, W_esVacia=O(1).

### Especificación de costo
- Cada implementación tiene diferentes costos. Es importante tener especificación de costo por implementación.
- Dependiendo del uso, conviene una u otra.

### TADs en Haskell
- Se implementan mediante **clases de tipos**: `class Cola t where ...`.
- Una implementación es una **instancia**: `instance Cola [] where ...`.
- Uso con funciones polimórficas en el TAD: `ciclar :: Cola t ⇒ Int → t a → t a`.
- La función solo puede suponer el comportamiento de la especificación.

### Resumen: Especificación / Implementación / Uso
- **Especificación**: qué operaciones hay y cómo se comportan. Única.
- **Implementación**: cómo se realizan y cuánto cuestan. Puede haber varias.
- **Uso**: solo supone la especificación. Elige implementación por menor costo.

---

## Apunte 07 — Inducción

### Razonamiento ecuacional
- Haskell permite razonar ecuacionalmente (=, no ==) como en álgebra.
- Ejemplo: `reverse [x] = reverse (x:[]) = reverse [] ++ [x] = [] ++ [x] = [x]`.

### Patrones disjuntos
- Conviene que los patrones sean disjuntos para no depender del orden de las ecuaciones.
- `esCero 0 = True`, `esCero n | n ≢ 0 = False`.

### Extensionalidad
- `f = g ⇔ ∀x. f x = g x`. Visión de caja negra: solo importa el comportamiento ante argumentos.

### Análisis por casos
- Se hacen casos por los constructores del tipo (ej: `not False` y `not True`).

### Inducción sobre N
- **Primera forma**: probar P(0) (caso base) y P(m) → P(m+1) (paso inductivo).
- **Segunda forma** (inducción completa/fuerte): probar que si P(i) para todo i < m entonces P(m). No hay caso base explícito.
- Ambas formas son igual de completas/fuertes.

### Inducción sobre otros conjuntos
- Se puede inducir sobre la altura de un árbol o longitud de una lista mapeando a N mediante una función f: A → N.
- Se transforma propiedad sobre A en propiedad sobre N: Q(n) = ∀a. f a = n ⇒ P(a).

### Inducción estructural
- Para tipo algebraico T, probar P(t):
  1. P(t) para todo constructor no recursivo.
  2. Para constructor recursivo con subinstancias t₁..tₖ: si P(tᵢ) para todo i entonces P(t).
- Variante: suponer P(t') para todo t' estrictamente dentro de t.
- Ejemplo para `Bin = Null | Leaf | Node Bin Bin`: probar P(Null), P(Leaf), y P(u)∧P(v) → P(Node u v).
- Ejemplo para listas: probar P([]) y P(xs) → P(x:xs).

### Compilador correcto (ejemplo estrella)
- Lenguaje aritmético: `data Expr = Val Int | Add Expr Expr`.
- Semántica denotacional: `eval (Val n) = n`, `eval (Add x y) = eval x + eval y`.
- Máquina de stack: `type Stack = [Int]`, `data Op = PUSH Int | ADD`, `type Code = [Op]`.
- Ejecución: `exec [] s = s`, `exec (PUSH n : c) s = exec c (n:s)`, `exec (ADD : c) (m:n:s) = exec c (n+m:s)`.
- Compilador: `comp (Val n) = [PUSH n]`, `comp (Add x y) = comp x ++ comp y ++ [ADD]`.
- **Correctitud**: ∀e. exec (comp e) [] = [eval e].
- Prueba por inducción estructural sobre Expr. Caso Val: directo. Caso Add:
  - Necesita **Lema 1**: ∀c,d,s. exec (c ++ d) s = exec d (exec c s).
  - La prueba originalestanca en el caso Add. Hay que **generalizar la hipótesis inductiva**:
    - Original: ∀e. exec (comp e) [] = [eval e]
    - Generalizada: ∀e,s. exec (comp e) s = eval e : s
  - Con la propiedad generalizada, la hipótesis inductiva es más fuerte y la prueba avanza.
- Generalizar la hipótesis inductiva a veces facilita la prueba.

---

## Apunte 08 — Paralelo

### Mergesort en listas vs árboles
- En listas: S_msort ∈ O(n) (split y merge son secuenciales, O(n) cada uno).
- Las listas no son buenas para paralelizar: la estructura de datos influye en la profundidad.
- Se usa árbol: `data BT a = Empty | Node (BT a) a (BT a)`.
- Ventajas: split es O(1) (ya está dividido), merge se puede paralelizar.

### Merge sobre árboles
- `merge (Node l1 x r1) t2 = let (l2,r2) = splitAt t2 x; (l',r') = merge l1 l2 || merge r1 r2 in Node l' x r'`.
- `splitAt` separa un árbol en menores y mayores a un valor dado. O(h) de profundidad.
- S_merge(h1,h2) ∈ **O(h1 · h2)**. Si árboles balanceados: h ∈ O(lg n).

### Rebalueo
- El análisis S_merge ∈ O(h1·h2) supone árboles balanceados, pero merge puede desbalancear.
- Se agrega `rebalance :: BT a → BT a` después del merge.
- S_msort(n) ∈ **O((lg n)³)**.

### mapT
- `mapT :: (a→b) → T a → T b` sobre `data T a = Empty | Leaf a | Node (T a) (T a)`.
- `mapT f (Node l r) = let (l',r') = mapT f l || mapT f r in Node l' r'`.
- Si W_f=O(1), S_f=O(1): W(mapT f) ∈ O(n), S(mapT f) ∈ O(lg n).

### reduceT
- `reduceT :: (a→a→a) → a → T a → a`.
- `reduceT f e (Node l r) = let (l',r') = reduceT f e l || reduceT f e r in f l' r'`.
- sumT = reduceT (+) 0. flattenT = reduceT (++) [].
- Si f ∈ O(1): W_reduceT ∈ O(n), S_reduceT ∈ O(lg n).

### mapreduce
- Hacer mapT y luego reduceT es ineficiente: mapTgenera un árbol que se consume inmediatamente.
- `mapreduce f g e Empty = e`, `mapreduce f g e (Leaf a) = f a`, `mapreduce f g e (Node l r) = let (l',r') = mr l || mr r in g l' r'`.
- Combina map y reduce en un solo recorrido.

---

## Apunte 09 — Secuencias

### TAD Seq
- TAD para representar secuencias. Facilita programación paralela.
- Operaciones: empty, singleton, length, nth, toSeq, tabulate, map, filter, append, take, drop, showt.
- `showt : Seq a → TreeView a` donde `data TreeView a = EMPTY | ELT a | NODE (Seq a) (Seq a)`.
  - Si |s|=0 → EMPTY; si |s|=1 → ELT s₀; si |s|>1 → NODE (take s |s|/2)(drop s |s|/2).

### reduce
- `reduce :: (a→a→a) → a → Seq a → a`.
- Si ⊕ es asociativa y e es neutro: coincide con foldr ⊕ e y foldl ⊕ e.
- Si ⊕ no es asociativa: el **orden de reducción** afecta el resultado.
- El orden de reducción es parte del TAD (no de la implementación).
- **Árbol de reducción**: se construye con `toTree : Seq a → Tree a`.
  - `data Tree a = Leaf a | Node (Tree a) (Tree a)`.
  - Si |s|=2^k, resulta un árbol binario perfecto.
  - `reduceT ⊕ (Leaf x) = x`, `reduceT ⊕ (Node l r) = (reduceT ⊕ l) ⊕ (reduceT ⊕ r)`.
- Especificación: reduce ⊕ b s = b ⊕ (reduceT ⊕ (toTree s)) si |s|>0.

### DyC con reduce
- `dyc s = case showt s of EMPTY → val | ELT v → base v | NODE l r → let (l',r') = dyc l || dyc r in combine l' r'`.
- Equivale a: `reduce combine val (map base s)`.

### MCSS ( Máxima Subsecuencia Contigua) con reduce
- Devuelve tupla (resultado, máximo prefijo, máximo sufijo, suma total).
- `val = (0,0,0,0)`, `base v = let v' = max v 0 in (v',v',v',v')`.
- `combine (m,p,s,t) (m',p',s',t') = (max (s+p') m m', max p (t+p'), max s' (s+t'), t+t')`.
- Solución: `reduce combine val (map base s)`.
- También se puede resolver con scan: `mcss s = let x = scan + 0 s; m = scan min ∞ x in max (tabulate (λj → x_j - m_j) |s|)`.

### Costo general de reduce y scan con ⊕ arbitrario
- Se define `Or(reduce ⊕ b s) = {aplicaciones de ⊕ en el árbol de reducción}`.
- `W(reduce ⊕ b s) = O(|s| + Σ W(x⊕y))` para (x⊕y) ∈ Or.
- `S(reduce ⊕ b s) = O(lg |s| · max S(x⊕y))` para (x⊕y) ∈ Or.
- Análogamente `Os` para scan.
- El orden de reducción afecta **tanto el resultado** (si ⊕ no asociativa) **como el costo**.
- Ejemplo: `sort s = reduce merge empty (map singleton s)`:
  - Orden lineal (x₀⊕(x₁⊕...)): W=O(n²), S=O(n lg n).
  - Orden balanceado: W=O(n lg n). ¡Cambio notable!

### scan
- `scan :: (a→a→a) → a → Seq a → (Seq a, a)`.
- Especificación (si ⊕ asociativa): `scan ⊕ b s = (tabulate (λi → reduce ⊕ b (take s i)) |s|, reduce ⊕ b s)`.
- Implementación ingenua: muy ineficiente.
- **Implementación por contracción/expansión**:
  1. **Contracción**: contraer la secuencia a la mitad agrepando elementos adyacentes: `hx₀⊕x₁, x₂⊕x₃, ...i`.
  2. Llamar recursivamente a scan sobre la secuencia contraída.
  3. **Expansión**: a partir del resultado recursivo, reconstruir el resultado grande:
     - Si i es par: `r_i = s'_{i/2}`
     - Si i es impar: `r_i = s'_{i/2} ⊕ s_{i-1}`
  - El total (último elemento) viene del resultado recursivo.
- Costos (con ⊕ ∈ O(1)): W(n) = W(n/2) + kn → **O(n)**. S(n) = S(n/2) + k → **O(lg n)**.
- El orden de reducción de scan **no coincide** con el de reduce sobre prefijos.

### Arreglos persistentes
- Acceso constante a cualquier índice, sin updates destructivos.
- Operaciones: length, nth, fromList, tabulate, subarray.
- Costos:
  - length: O(1)/O(1)
  - nth: O(1)/O(1)
  - fromList: O(|xs|)/O(|xs|)
  - tabulate f n: W = ΣW(f i), S = maxS(f i)
  - subarray: O(1)/O(1)
- Con arreglos persistentes, el TAD Seq tiene costos:
  - empty/singleton/length/nth/take/drop/showt: O(1) W y S (excepto take/drop O(|s|)/O(1))
  - append: O(|s|+|t|)/O(1)
  - map/filter: W = ΣW(f x), S = maxS(f x)
  - reduce: O(|s|)/O(lg |s|)
  - scan: O(|s|)/O(lg |s|)

### collect
- `collect :: Seq (a × b) → Seq (a × Seq b)`.
- Recolecta todos los datos asociados a cada clave. El resultado está ordenado por clave.
- Implementación en 2 pasos: (1) ordenar por clave → junta claves iguales; (2) agrupar valores de claves iguales.
- Costo dominado por el sort: W = O(W_c · n lg n), S = O(S_c · lg² n).

### Map-reduce (Google)
- Paradigma inventado por Google. Implementación open-source: Hadoop.
- En realidad es: **map → collect → reduce** (no solo map-reduce).
- `mapCollectReduce apv red s = let pairs = join (map apv s); groups = collect pairs in map red groups`.
- apv genera pares clave/valor; collect agrupa; red reduce cada grupo.
- Ejemplo contador de palabras: apv mapea docs a pares (palabra,1); red reduce con (+).

---

## Items de estudio (items.txt)

=== Apunte 01 — Modelo de Costo ===
1. Notación asintótica: O, Ω, Θ
2. Modelo de costo basado en lenguajes: Trabajo (W) y Profundidad (S), paralelismo P = W/S
3. Principio del Scheduler Voraz (Brent)
4. DyC general: W_DyC y S_DyC, Mergesort como ejemplo (W_msort ∈ O(n lg n), S_msort ∈ O(n))

=== Apunte 02 — Recurrencias ===
5. Método de sustitución
6. Árboles de recurrencia
7. Funciones b-suaves, funciones suaves, regla de suavidad
8. Teorema Maestro

=== Apunte 04 — Tipos en Haskell ===
9. Sinónimos de tipos (type), declaraciones data, constructores de tipos (Maybe, Either), tipos recursivos
10. Codificación de Huffman: árboles, decodificación, codificación, construcción

=== Apunte 05 — Estructuras Inmutables ===
11. Estructuras inmutables vs efímeras, sharing
12. BSTs: member, insert, delete, sharing
13. RBTs: invariantes, inserción y rebalanceo (balance)
14. Leftist Heap: rango, invariante leftist, merge, insert, findMin, deleteMin

=== Apunte 06 — TADs ===
15. Qué es un TAD: especificación algebraica / por modelos, implementación, uso, especificación de costo

=== Apunte 07 — Inducción ===
16. Razonamiento ecuacional, análisis por casos, extensionalidad
17. Inducción sobre naturales (1ra y 2da forma) e inducción estructural
18. Compilador correcto: eval, comp, exec, prueba por inducción estructural, generalización de la hipótesis inductiva

=== Apunte 08 — Paralelo ===
19. Paralelización de Mergesort: msort en listas vs árboles, merge sobre árboles, rebalance, profundidad O((lg n)³)
20. reduceT, mapT vs mapreduce

=== Apunto 09 — Secuencias ===
21. reduce: orden de reducción, árbol de reducción, DyC con reduce, MCSS con reduce
22. Costo general de reduce y scan cuando ⊕ ∉ O(1): Or, Os
23. scan: especificación, implementación ingenua, contracción/expansión, orden de reducción, costos
24. Arreglos persistentes: operaciones y costos
25. collect, map-reduce en Google