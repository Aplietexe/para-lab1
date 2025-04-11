module Basica.BasicaDoble where

import Basica.Comun
import Dibujo
import Interp

data Basica = Triangulo | TrianguloVioleta

ejemplo :: Dibujo Basica
ejemplo = apilar 1 1 (basica Triangulo) (rotar (basica TrianguloVioleta))

interpBas :: Basica -> ImagenFlotante
interpBas Triangulo = triangulo
interpBas TrianguloVioleta = trianguloVioleta
