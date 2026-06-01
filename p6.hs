data BTree a = Empty | Node Int (BTree a) a (BTree a) deriving Show
--nth :: BTree a → Int → a, calcula el n-´esimo elemento de una secuencia
nth :: BTree a -> Int -> a
nth (Node c l x r) k = 
    if k == ((sizeB l) + 1) then x
    else 
        if k > (sizeB l) then nth r (k - (sizeB l) - 1)
        else nth l k

--W(nth) = k1*h donde h es la altura del arbol
--D(nth) = k1*h
--En terminos de O esta funcion es O(n) ya que no nos asegura que el arbol este balanceado

sizeB:: BTree a -> Int
sizeB Empty = 0
sizeB (Node c _ _ _) = c

--cons :: a → BTree a → BTree a, la cual inserta un elemento al comienzo de la secuencia
cons::(Ord a) => a -> BTree a -> BTree a
cons a Empty = (Node 1 Empty a Empty)
cons a (Node c l x r) = (Node (c+1) (cons a l) x r)

--W(cons) = k1*hi donde hi es la profundidad de la hoja izquierda
--D(cons) = W(cons) ya que hay una unica llamada recursiva y un orden secuencial de ejecucion
--En terminos de O esta funcion es O(n) ya que en el peor caso los elementos fueron agregados con cons
-- y hi = n

--tabulate :: (Int → a) → Int → BTree a, la cual dada una funci´on f y un entero n devuelve una secuencia de
--tama˜no n, donde cada elemento de la secuencia es el resultado de aplicar f al ´ındice del elemento.
tabulate:: (Int -> a) -> Int -> BTree a
tabulate f n = tabulateaux f 1 n

tabulateaux::(Int->a) -> Int -> Int -> BTree a
tabulateaux f lo hi =
    if lo > hi then Empty
    else (Node tam l (f mid) r)
    where
        mid = (lo + hi)`div`2
        l = tabulateaux f lo (mid - 1)
        r = tabulateaux f (mid + 1) hi
        tam = (hi - lo) + 1

--W(n) es k1 + 2*W(n/2) ==> W(n) pertenece a O(n)
--D(n) = D(n/2) + k2 = k2*log_2(n) ==> D(n) pertenece a O(log_2(n))

-- map :: (a → b) → BTree a → BTree b, la cual dada una funci´on f y una secuencia s, devuelve el resultado de
-- aplicar f sobre cada elemento de s.
mapB f Empty = Empty
mapB f (Node c l x r) =
    (Node c nl nx nr)
    where
        nx = f x
        nl = (mapB f l)
        nr = (mapB f r)

--W(h) = W(f) + W(h1) + W(h2) donde h1 y h2 son las alturas de los hijos ==> W(f)*n 
--D(h) = k1 + max(h1, h2) donde ... ==> en el peor caso es O(n)

--take :: Int → BTree a → BTree a, tal que dados un entero n y una secuencia s devuelve los primeros n
--elementos de s

takeB 0 t = Empty
takeB k (Node c l x r) =
    if k >= c then (Node c l x r)
    else if k > (sizeB l) 
        then (Node k l x (takeB (k - (sizeB l) - 1) r))
        else (takeB k l)

--TakeB trabaja de manera secuencial, con una unica llamada recursiva ==> W(n) = D(n)
--W(h) = k1 + W(h-1) ya que en el peor de los casos los arboles hijos tienen altura igual al padre menos 1
-- ==> W(h) pertenece a O(n)


--drop :: Int → BTree a → BTree a, tal que dados un entero n y una secuencia s devuelve la secuencia s sin los
--primeros n elementos.

dropB k Empty = Empty
dropB 0 t     = t
dropB k (Node c l x r) = 
    if k >= c then Empty
    else
        if k == ((sizeB l) + 1) then r
        else if k > (sl + 1) then dropB (k - sl - 1) r
        else (Node (c-k) (dropB k l) x r)
    where
        sl = (sizeB l)

--Nuevamente, dropB tiene una unica llamada recursiva y por ende un funcionamiento secuencial W(h) = D(h)
--donde h es la altura del arbol, veamos W(h) = k1 + W(h-1) ==> W(h) pertenece a O(h) si el arbol no esta balanceado

--Definir una funcion mcss :: (Num a, Ord a) ⇒ Tree a → a, que calcule la m´axima suma de una subsecuencia
--contigua de una secuencia dada, en terminos de map reduce.

data Tree a = E | Leaf a | Join (Tree a) (Tree a)

reduce :: (a -> a -> a) -> Tree a -> a
reduce f (Leaf a)   = a
reduce f (Join l r) = f (reduce f l) (reduce f r)

mcss::(Num a, Ord a) => Tree a -> a
mcss t = 
    let (mss, _, _, _) = reduce combinar (mapTree f4 t)
    in mss
    where
        f4::(Num a, Ord a) => a -> (a, a, a, a)
        f4 a = ((max a 0), (max a 0), (max a 0), a)
        -- mss = max subseq sum
        -- mps = max prefix sum  
        -- mcs = max suffix sum
        -- ts  = total sum
        combinar (mss1, mps1, mcs1, ts1) (mss2, mps2, mcs2, ts2) =
            ((maximum [mss1, mss2, (mcs1 + mps2)]),          --Me quedo con la izq, la der, o la combineta
             (max mps1 (ts1 + mps2)),                        --Actualizo maximo prefijo
             (max mps2 (ts2 + mcs1)),                        --Actualizo maximo sufijo
             (ts1 + ts2)                                     --Actualizo suma total
            )

mapTree f E = E
mapTree f (Leaf a) = (Leaf (f a))
mapTree f (Join a b) = (Join nl nr)
    where
        nl = mapTree f a
        nr = mapTree f b

--W_mcss(n) = W_reduce(n) + W_mapTree_f4(n) = W_reduce(n) + (k1 + W_mapTree_f4(l) + W_mapTree_f4(r)) = k2*n + k1*n = (k1+k2)*n

--Luego, como l+r = n y W_f4(n) = k1 ==> W_mapTree_f4(n) = k1*n

--D_mcss(n) = D_reduce(n) + D_mapTree_f4(n) = D_reduce(n) + max(D_mapTree_f4(l), D_mapTree_f4(r)) + k1
-- = D_reduce(n) + k1*h (depende de la altura del arbol)
--  D_reduce(h) = k2 + max(D_reduce(l), D_reduce(r)) = k2*h
--D_mcss(n) = (k1+k2)*h

sufijos :: Tree Int -> Tree (Tree Int)
sufijos t = sufijosAux t E

sufijosAux :: Tree Int -> Tree Int -> Tree (Tree Int)
sufijosAux (Leaf x) resto   = Leaf resto
sufijosAux (Join l r) resto = 
    (Join (sufijosAux l (Join r resto))
          (sufijosAux r resto))

--MACABRO
conSufijos :: Tree Int -> Tree (Int,Tree Int)
-- la cual dado un ´arbol t reemplaza cada elemento v de t por el par (v, sufijos de v en t)
conSufijos t = sufijosAux2 t E

sufijosAux2 :: Tree Int -> Tree Int -> Tree (Int, Tree Int)
sufijosAux2 (Leaf x) resto   = Leaf (x, resto)
sufijosAux2 (Join l r) resto = 
    (Join (sufijosAux2 l (Join r resto))
          (sufijosAux2 r resto))

maxT::Tree Int -> Int
maxT E = 0
maxT (Leaf x) = x
maxT (Join a b) = (max (maxT a) (maxT b))

maxAll:: Tree (Tree Int) -> Int
maxAll t = reduce max (mapTree maxT t)

mejorGanancia :: Tree Int -> Int
mejorGanancia t = 
    let arbol_2 = conSufijos t
    in reduce max (mapTree ganancia arbol_2)
    where
        ganancia::(Int, Tree Int) -> Int
        ganancia (x, suf) = ((maxT suf) - x)
    






