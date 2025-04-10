module Basica.Ejemplo where

import Basica.Comun
import Dibujo
import Interp

type Basica = ()

ejemplo :: Dibujo Basica
ejemplo = espejar (basica ())

interpBas :: Basica -> ImagenFlotante
interpBas () = formaF
