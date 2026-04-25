module Lab01 where

import Data.List

{-
1) Corregir los siguientes programas de modo que sean aceptados por GHCi.
-}

-- a)
not b = case b of
  True -> False
  False -> True
-- b)
ina []          =  error "empty list"
ina [x]         =  []
ina (x:xs)      =  x : ina xs

-- d)
list123 = 1 : 2 : 3 : []

-- e)
[]     ++! ys = ys
(x:xs) ++! ys = x : xs ++! ys

-- f)
addToTail x xs = map (+x) (tail xs)

-- g)
listmin xs = (head . sort) xs

-- h) (*)
smap f [] = []
smap f [x] = [f x]
smap f (x:xs) = f x : smap f xs
{-
2. Definir las siguientes funciones y determinar su tipo:
-}
-- a) five, que dado cualquier valor, devuelve 5
five x = 5

--b) apply, que toma una función y un valor, y devuelve el resultado de
--aplicar la función al valor dado
apply f x = f x
{-
c) ident, la función identidad
-}
ident x = x
{-
d) first, que toma un par ordenado, y devuelve su primera componente
-}
first (x, y) = x
{-
e) derive, que aproxima la derivada de una función dada en un punto dado
-}
derive f x = ((f (x + 0.0001)) - (f x)) / 0.0001
{-
f) sign, la función signo
-}
sign x | x >= 0 = 1
       | otherwise = -1
{-
g) vabs, la función valor absoluto (usando sign y sin usarla)
-}
vabs x | x >= 0 = x
       | otherwise = -x
{-
h) pot, que toma un entero y un número, y devuelve el resultado de
elevar el segundo a la potencia dada por el primero
-}
pot n x = x**n
{-
i) xor, el operador de disyunción exclusiva
-}
xor a b | a && b = False
        | a || b = True
        | otherwise = False 
{-
j) max3, que toma tres números enteros y devuelve el máximo entre ellos
-}
max3 a b c | a >= b && a >= c = a
               | b >= a && b >= c = b
               | otherwise  = c

--k) swap, que toma un par y devuelve el par con sus componentes invertidas
swap (x, y) = (y, x)

{-
3) Definir una función que determine si un año es bisiesto o no, de
acuerdo a la siguiente definición:

año bisiesto 1. m. El que tiene un día más que el año común, añadido al mes de febrero. Se repite
cada cuatro años, a excepción del último de cada siglo cuyo número de centenas no sea múltiplo
de cuatro. (Diccionario de la Real Academia Espaola, 22ª ed.)

¿Cuál es el tipo de la función definida?
-}
bisiesto :: Integral a => a -> Bool
bisiesto x = ((x `mod` 4) == 0) && if (x `mod` 400) == 0 then False else True
{-
4)

Defina un operador infijo *$ que implemente la multiplicación de un
vector por un escalar. Representaremos a los vectores mediante listas
de Haskell. Así, dada una lista ns y un número n, el valor ns *$ n
debe ser igual a la lista ns con todos sus elementos multiplicados por
n. Por ejemplo,

[ 2, 3 ] *$ 5 == [ 10 , 15 ].

El operador *$ debe definirse de manera que la siguiente
expresión sea válida:

-}
[] *$ y = []
(x:xs) *$ y = (x*y): xs *$ y
{-
5) Definir las siguientes funciones usando listas por comprensión:

a) 'divisors', que dado un entero positivo 'x' devuelve la
lista de los divisores de 'x' (o la lista vacía si el entero no es positivo)
-}
divisors x = [b | b <- [1..x], (x `mod` b) == 0]
{-
b) 'matches', que dados un entero 'x' y una lista de enteros descarta
de la lista los elementos distintos a 'x'
-}
matches x xs = [b |b<-xs, b == x]
{-
c) 'cuadrupla', que dado un entero 'n', devuelve todas las cuadruplas
'(a,b,c,d)' que satisfacen a^2 + b^2 = c^2 + d^2,
donde 0 <= a, b, c, d <= 'n'
-}
cuadrupla n = [(a, b, c, d) | a<-[0..n], b<-[0..n], c<-[0..n], d<-[0..n], ((a**2)+(b**2) == (c**2)+(d**2))]
{-
(d) 'unique', que dada una lista 'xs' de enteros, devuelve la lista
'xs' sin elementos repetidos
-}
unique :: [Int] -> [Int]
--unique xs = [x | (x,i) <- zip xs [0..], not (elem x (take i xs))]
unique xs = [b | b<-[0.. last(sort xs)], elem b xs]
{- 
6) El producto escalar de dos listas de enteros de igual longitud
es la suma de los productos de los elementos sucesivos (misma
posición) de ambas listas.  Definir una función 'scalarProduct' que
devuelva el producto escalar de dos listas.

Sugerencia: Usar las funciones 'zip' y 'sum'. -}
prod_escalar :: [Int] -> [Int] -> Int
-- prod_escalar [][] = 0
-- prod_escalar (x:xs) (y:ys) = (x*y) + prod_escalar xs ys

prod_escalar xs ys = sum [x*y | (x, i1) <- zip xs [0..], (y, i2) <- zip ys [0..], i1 == i2]
{-
7) Definir mediante recursión explícita
las siguientes funciones y escribir su tipo más general:

a) 'suma', que suma todos los elementos de una lista de números
-}
suma::Num a => [a] -> a
suma [] = 0
suma (x:xs) = x + suma xs
{-
b) 'alguno', que devuelve True si algún elemento de una
lista de valores booleanos es True, y False en caso
contrario
-}
alguno::[Bool] -> Bool
alguno [] = False
alguno (x:xs) = x || alguno xs
{-

c) 'todos', que devuelve True si todos los elementos de
una lista de valores booleanos son True, y False en caso
contrario
-}
todos::[Bool] -> Bool
todos [] = True
todos (x:xs) = x && todos xs
{-
{-
d) 'codes', que dada una lista de caracteres, devuelve la
lista de sus ordinales
-}
-}

{-
DESCOMENTAR, Esta comentado porque rompe el Syntax Highlighter
codes::[Char] -> [Integer]
codes [] = []
codes (x:xs) = [i| (a, i) <- zip ['a'..'z'] [1..], x == a] ++ codes xs
-} 
{-
e) 'restos', que calcula la lista de los restos de la
división de los elementos de una lista de números dada por otro
número dado
-}
restos::Integral a => [a] -> a -> [a]
restos [] y = []
restos (x:xs) y = (x `mod` y) : restos xs y
{-
f) 'cuadrados', que dada una lista de números, devuelva la
lista de sus cuadrados
-}
cuadrados::Num a => [a] -> [a]
cuadrados [] = []
cuadrados (x:xs) = [x*x] ++ cuadrados xs
{-
g) 'longitudes', que dada una lista de listas, devuelve la
lista de sus longitudes
-}
longitudes:: [[a]] -> [Int]
longitudes [] = []
longitudes (x:xs) = (length x) : longitudes xs 
{-
h) 'orden', que dada una lista de pares de números, devuelve
la lista de aquellos pares en los que la primera componente es
menor que el triple de la segunda
-}
orden::(Num a, Ord a) => [(a,a)] -> [(a,a)]
orden [] = []
orden ((x,y): xs) | x < (y*3) = (x,y): orden xs
                  | otherwise = orden xs
{-
i) 'pares', que dada una lista de enteros, devuelve la lista
de los elementos pares
-}
pares::Integral a => [a] -> [a]
pares xs = [i | i<-xs, even i]
{-
j) 'letras', que dada una lista de caracteres, devuelve la
lista de aquellos que son letras (minúsculas o mayúsculas)
-}
letras::[Char] -> [Char]
letras [] = []
letras (c:cs) | (elem c ['a'..'z']) || (elem c ['A'..'Z']) = c : letras cs
              | otherwise = letras cs
{-
k) 'masDe', que dada una lista de listas 'xss' y un
número 'n', devuelve la lista de aquellas listas de 'xss'
con longitud mayor que 'n' 
-}
