module Dibujo
  ( Dibujo,
    basica,
    rotar,
    rotar45,
    espejar,
    apilar,
    juntar,
    encimar,
    comp,
    r180,
    r270,
    (.-.),
    (///),
    (^^^),
    cuarteto,
    encimar4,
    ciclar,
    pureDib,
    mapDib,
    foldDib,
  )
where

-- Definir el lenguaje via constructores de tipo
data Dibujo a
  = Basica a
  | Rotar (Dibujo a)
  | Rotar45 (Dibujo a)
  | Espejar (Dibujo a)
  | Apilar Float Float (Dibujo a) (Dibujo a)
  | Juntar Float Float (Dibujo a) (Dibujo a)
  | Encimar (Dibujo a) (Dibujo a)
  deriving (Eq, Show)

basica :: a -> Dibujo a
basica = Basica

rotar :: Dibujo a -> Dibujo a
rotar = Rotar

rotar45 :: Dibujo a -> Dibujo a
rotar45 = Rotar45

espejar :: Dibujo a -> Dibujo a
espejar = Espejar

apilar :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
apilar = Apilar

juntar :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
juntar = Juntar

encimar :: Dibujo a -> Dibujo a -> Dibujo a
encimar = Encimar

-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a
comp f 0 x = x
comp f n x
  | n < 0 = error "n no puede ser negativo"
  | otherwise = comp f (n - 1) (f x)

-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a
r180 = comp rotar 2

r270 :: Dibujo a -> Dibujo a
r270 = comp rotar 3

-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = Apilar 1 1

-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = Juntar 1 1

-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = Encimar

-- Dadas cuatro dibujos las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto p q r s = (p /// q) .-. (r /// s)

-- Una dibujo repetido con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 d = d ^^^ rotar d ^^^ r180 d ^^^ r270 d

-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar d = cuarteto d (rotar d) (r180 d) (r270 d)

-- Transformar un valor de tipo a como una Basica.
pureDib :: a -> Dibujo a
pureDib = Basica

-- map para nuestro lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f (Basica d) = Basica $ f d
mapDib f (Rotar d) = Rotar $ mapDib f d
mapDib f (Rotar45 d) = Rotar45 $ mapDib f d
mapDib f (Espejar d) = Espejar $ mapDib f d
mapDib f (Apilar x y d1 d2) = Apilar x y (mapDib f d1) (mapDib f d2)
mapDib f (Juntar x y d1 d2) = Juntar x y (mapDib f d1) (mapDib f d2)
mapDib f (Encimar d1 d2) = Encimar (mapDib f d1) (mapDib f d2)

-- Funcion de fold para Dibujos a
foldDib ::
  (a -> b) ->
  (b -> b) ->
  (b -> b) ->
  (b -> b) ->
  (Float -> Float -> b -> b -> b) ->
  (Float -> Float -> b -> b -> b) ->
  (b -> b -> b) ->
  Dibujo a ->
  b
foldDib fBasica fRotar fRotar45 fEspejar fApilar fJuntar fEncimar = go
  where
    go (Basica d) = fBasica d
    go (Rotar d) = fRotar $ go d
    go (Rotar45 d) = fRotar45 $ go d
    go (Espejar d) = fEspejar $ go d
    go (Apilar x y d1 d2) = fApilar x y (go d1) (go d2)
    go (Juntar x y d1 d2) = fJuntar x y (go d1) (go d2)
    go (Encimar d1 d2) = fEncimar (go d1) (go d2)
