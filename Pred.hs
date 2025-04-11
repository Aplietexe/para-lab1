module Pred where

import Dibujo

type Pred a = a -> Bool

-- Para la definiciones de la funciones de este modulo, no pueden utilizar
-- pattern-matching, sino alto orden a traves de la funcion foldDib, mapDib

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por el resultado de llamar a la función indicada por el
-- segundo argumento con dicha figura.
-- Por ejemplo, `cambiar (== Triangulo) (\x -> Rotar (Basica x))` rota
-- todos los triángulos.
cambiar :: Pred a -> (a -> Dibujo a) -> Dibujo a -> Dibujo a
cambiar pred f = foldDib (\x -> if pred x then f x else basica x) rotar rotar45 espejar apilar juntar encimar

-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool
anyDib = flip foldDibBin (||)

-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool
allDib = flip foldDibBin (&&)

-- Hay 4 rotaciones seguidas.
esRot360 :: Pred (Dibujo a)
esRot360 d = foldDib (const 0) (+ 1) (const 0) (const 0) (const4 0) (const4 0) (const2 0) d >= 4

-- Hay 2 espejados seguidos.
esFlip2 :: Pred (Dibujo a)
esFlip2 d = foldDib (const 0) (const 0) (const 0) (+ 1) (const4 0) (const4 0) (const2 0) d >= 2

data Superfluo = RotacionSuperflua | FlipSuperfluo deriving (Eq, Show)

---- Chequea si el dibujo tiene una rotacion superflua
errorRotacion :: Dibujo a -> [Superfluo]
errorRotacion d = fst $ f d
  where
    f = foldDib (const ([], 0)) fRotar pasar pasar (const2 concatenar) (const2 concatenar) concatenar
    fRotar (xs, n) = if n == 3 then (RotacionSuperflua : xs, 0) else (xs, n + 1)
    pasar (xs, _) = (xs, 0)
    concatenar (xs, _) (ys, _) = (xs ++ ys, 0)

-- Chequea si el dibujo tiene un flip superfluo
errorFlip :: Dibujo a -> [Superfluo]
errorFlip d = fst $ f d
  where
    f = foldDib (const ([], 0)) pasar pasar fEspejar (const2 concatenar) (const2 concatenar) concatenar
    pasar (xs, _) = (xs, 0)
    fEspejar (xs, n) = if n == 1 then (FlipSuperfluo : xs, 0) else (xs, n + 1)
    concatenar (xs, _) (ys, _) = (xs ++ ys, 0)

-- Aplica todos los chequeos y acumula todos los errores, y
-- sólo devuelve la figura si no hubo ningún error.
checkSuperfluo :: Dibujo a -> Either [Superfluo] (Dibujo a)
checkSuperfluo d = if null errores then Right d else Left errores
  where
    errores = errorRotacion d ++ errorFlip d
