-- Sacar del esqueleto final!
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use camelCase" #-}
module Interp where

import Dibujo
import Graphics.Gloss
import Graphics.Gloss.Data.Point.Arithmetic qualified as V
import Graphics.Gloss.Data.Vector

-- Gloss provee el tipo Vector y Picture.
type ImagenFlotante = Vector -> Vector -> Vector -> Picture

type Interpretacion a = a -> ImagenFlotante

mitad :: Vector -> Vector
mitad = (0.5 V.*)

-- Interpretaciones de los constructores de Dibujo

-- interpreta el operador de rotacion
interp_rotar :: ImagenFlotante -> ImagenFlotante
interp_rotar f d w h = f (d V.+ w) h (V.negate w)

-- interpreta el operador de espejar
interp_espejar :: ImagenFlotante -> ImagenFlotante
interp_espejar f d w = f (d V.+ w) (V.negate w)

-- interpreta el operador de rotacion 45
interp_rotar45 :: ImagenFlotante -> ImagenFlotante
interp_rotar45 f d w h = f (d V.+ c) c (mitad (h V.- w))
  where
    c = mitad (w V.+ h)

-- interpreta el operador de apilar
interp_apilar :: Float -> Float -> ImagenFlotante -> ImagenFlotante -> ImagenFlotante
interp_apilar m n f g d w h = pictures [f (d V.+ h') w (r V.* h), g d w h']
  where
    r' = n / (m + n)
    r = m / (m + n)
    h' = r' V.* h

-- interpreta el operador de juntar
interp_juntar :: Float -> Float -> ImagenFlotante -> ImagenFlotante -> ImagenFlotante
interp_juntar m n f g d w h = pictures [f d w' h, g (d V.+ w') (r' V.* w) h]
  where
    r' = n / (m + n)
    r = m / (m + n)
    w' = r V.* w

-- interpreta el operador de encimar
interp_encimar :: ImagenFlotante -> ImagenFlotante -> ImagenFlotante
interp_encimar f g d w h = pictures [f d w h, g d w h]

-- interpreta cualquier expresion del tipo Dibujo a
-- utilizar foldDib
interp :: Interpretacion a -> Dibujo a -> ImagenFlotante
interp f = foldDib f interp_rotar interp_rotar45 interp_espejar interp_apilar interp_juntar interp_encimar
