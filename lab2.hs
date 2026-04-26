module Lab02 where

{-
   Laboratorio 2
   EDyAII 2022
-}

import Data.List

-- 1) Dada la siguiente definición para representar árboles binarios:

data BTree a = E 
            |   Leaf a 
            | Node (BTree a) (BTree a) 
            deriving Show;

-- Definir las siguientes funciones:

-- a) altura, devuelve la altura de un árbol binario.

altura :: BTree a -> Int
altura E = 0
altura (Leaf a)= 0
altura (Node a b) = 1 + max (altura a) (altura b)

-- b) perfecto, determina si un árbol binario es perfecto (un árbol binario es perfecto si cada nodo tiene 0 o 2 hijos
-- y todas las hojas están a la misma distancia desde la raı́z).

perfecto :: BTree a -> Bool
perfecto E = True
perfecto (Leaf a) = True
perfecto (Node a b) = (hijos (Node a b)) && ((alturas 0 (Node a b)) /= -1)

alturas :: Int -> BTree a -> Int
alturas x E = x-1
alturas x (Leaf a) = x
alturas x (Node a b) = let l = (alturas (x+1) a);r = (alturas (x+1) b) in if (l == r) then l else -1  

hijos :: BTree a -> Bool
hijos (Node E E) = True
hijos (Node (Leaf a) (Leaf b)) = True
hijos (Node E _) = False
hijos (Node _ E) = False
hijos (Node (Leaf a) _) = False
hijos (Node _ (Leaf b)) = False
hijos (Node a b) = (hijos a) && (hijos b)
-- c) inorder, dado un árbol binario, construye una lista con el recorrido inorder del mismo.

inorder :: BTree a -> [a]
inorder E = []
inorder (Leaf a) = [a]
inorder (Node a b) = (inorder a) ++ (inorder b)

inorder2 :: BTree a -> [a]
inorder2 arbol = (aux arbol []) 

aux :: BTree a -> [a] -> [a]
aux E xs = xs
aux (Leaf a) xs = a:xs
aux (Node a b) xs = aux a (aux b xs)


-- 2) Dada las siguientes representaciones de árboles generales y de árboles binarios (con información en los nodos):

data GTree a = EG | NodeG a [GTree a]

data BinTree a = EB | NodeB (BinTree a) a (BinTree a) deriving Show;

{- Definir una función g2bt que dado un árbol nos devuelva un árbol binario de la siguiente manera:
   la función g2bt reemplaza cada nodo n del árbol general (NodeG) por un nodo n' del árbol binario (NodeB ), donde
   el hijo izquierdo de n' representa el hijo más izquierdo de n, y el hijo derecho de n' representa al hermano derecho
   de n, si existiese (observar que de esta forma, el hijo derecho de la raı́z es siempre vacı́o).
   
   
   Por ejemplo, sea t: 
       
                    A 
                 / | | \
                B  C D  E
               /|\     / \
              F G H   I   J
             /\       |
            K  L      M    
   
   g2bt t =
         
                  A
                 / 
                B 
               / \
              F   C 
             / \   \
            K   G   D
             \   \   \
              L   H   E
                     /
                    I
                   / \
                  M   J  
-}

g2bt :: GTree a -> BinTree a
g2bt EG = EB
g2bt (NodeG a hs) = (NodeB (children hs) a EB)

children :: [GTree a] -> BinTree a
children [] = EB
children ((NodeG a xs):rs) = (NodeB (children xs) a (children rs))


-- 3) Utilizando el tipo de árboles binarios definido en el ejercicio anterior, definir las siguientes funciones: 
{-
   a) dcn, que dado un árbol devuelva la lista de los elementos que se encuentran en el nivel más profundo 
      que contenga la máxima cantidad de elementos posibles. Por ejemplo, sea t:
            1
          /   \
         2     3
          \   / \
           4 5   6
                             
      dcn t = [2, 3], ya que en el primer nivel hay un elemento, en el segundo 2 siendo este número la máxima
      cantidad de elementos posibles para este nivel y en el nivel tercer hay 3 elementos siendo la cantidad máxima 4.
   -}

{-
   Pasamos a una lista el ultimo nivel completo, subdividimos el trabajo en 
      determinar el ultimo nivel completo
      pasar ese nivel a lista


-}

dcn :: BinTree a -> [a]
dcn EB = []
dcn (NodeB l x r) = (btl (ultimo_completo 0 (NodeB l x r)) (NodeB l x r))

ultimo_completo :: Int -> BinTree a -> Int
ultimo_completo x (NodeB EB y _) = x
ultimo_completo x (NodeB _ y EB) = x
ultimo_completo x (NodeB l y r) = let ul = (ultimo_completo (x+1) l)
                                      ur = (ultimo_completo (x+1) r)
                                      in min ur ul


btl :: Int -> BinTree a -> [a]
btl 0 (NodeB _ x _) = [x]
btl x (NodeB l y r) = (btl (x-1) l) ++ (btl (x-1) r)




{- b) maxn, que dado un árbol devuelva la profundidad del nivel completo
      más profundo. Por ejemplo, maxn t = 2   -}

maxn :: BinTree a -> Int
maxn EB = 0
maxn (NodeB l x r) = (ultimo_completo 0 (NodeB l x r)) + 1 
   

{- c) podar, que elimine todas las ramas necesarias para transformar
      el árbol en un árbol completo con la máxima altura posible. 
      Por ejemplo,
         podar t = NodeB (NodeB EB 2 EB) 1 (NodeB EB 3 EB)
-}

podar :: BinTree a -> BinTree a
podar = undefined