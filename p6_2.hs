data T a = E | N (T a) a (T a) deriving Show

altura :: T a -> Int
altura E = 0
altura (N l x r ) = 1 + (max (altura l) (altura r))

combinar :: T a -> T a -> T a
combinar E t2 = t2
combinar t1 E = t1
combinar (N E x1 r1) t2 = (N t2 x1 r1)
combinar (N l1 x1 E) t2 = (N l1 x1 t2)
combinar t1 (N E x2 r2) = (N t1 x2 r2)
combinar t1 (N l2 x2 E) = (N l2 x2 t1)
combinar t1 t2 =
    let izq = (left t1)
    in (N (elim_l t1) izq t2)
    where
        left (N E x r) = x
        left (N l _ _) = left l
        elim_l E = E
        elim_l (N E x r) = r 
        elim_l (N l x r) = (N (elim_l l) x r)

filterT::(a->Bool) -> T a -> T a
filterT p E = E
filterT p (N l x r) = 
    if (p x) 
    then (N (filterT p l) x (filterT p r))
    else (combinar (filterT p l) (filterT p r))

quicksortT :: T Int -> T Int
quicksortT E        = E
quicksortT (N l x r) =
    let 
        la_combineta = (combinar l r)
        menores_x = (filterT (< x) la_combineta)
        mayores_x = (filterT (> x) la_combineta)
    in (N (quicksortT menores_x) x (quicksortT mayores_x))
    
    