module Basica.BasicaDoble where

import Basica.Comun
import Dibujo
import Interp

data Basica = Triangulo | TrianguloVioleta

ejemplo :: Dibujo Basica
ejemplo = Apilar 1 1 (Figura Triangulo) (Rotar (Figura TrianguloVioleta))

interpBas :: Basica -> ImagenFlotante
interpBas Triangulo = triangulo
interpBas TrianguloVioleta = trianguloVioleta
