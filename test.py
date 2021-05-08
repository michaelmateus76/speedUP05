## Universidad Sergio Arboleda
## Materia: Computacion Paralela
## Profesor: John Corredor
## Ingenieria de sistemas y telecomunicaciones
## Autor: Michael Steven Pinilla Mateus

import simulador
import Cy_simulador
import time

### Inicializar variebles compartidas
AU = (149.6e6 * 1000)

### Inicializar variebles python
Psun = simulador.Body()
Psun.name = 'Sun'
Psun.mass = 1.98892 * 10 ** 30

Pearth = simulador.Body()
Pearth.name = 'Earth'
Pearth.mass = 5.9742 * 10 ** 24
Pearth.px = -1 * AU
Pearth.vy = 29.783 * 1000  # 29.783 km/sec

Pvenus = simulador.Body()
Pvenus.name = 'Venus'
Pvenus.mass = 4.8685 * 10 ** 24
Pvenus.px = 0.723 * AU
Pvenus.vy = -35.02 * 1000
   
### Inicializar variebles cython
Csun = Cy_simulador.Body()
Csun.name = 'Sun'
Csun.mass = 1.98892 * 10 ** 30

Cearth = Cy_simulador.Body()
Cearth.name = 'Earth'
Cearth.mass = 5.9742 * 10 ** 24
Cearth.px = -1 * AU
Cearth.vy = 29.783 * 1000  # 29.783 km/sec

Cvenus = Cy_simulador.Body()
Cvenus.name = 'Venus'
Cvenus.mass = 4.8685 * 10 ** 24
Cvenus.px = 0.723 * AU
Cvenus.vy = -35.02 * 1000

### Tiempos
inicio = time.time()
simulador.loop([Psun, Pearth, Pvenus])
tiempoPy = time.time() - inicio


inicio = time.time()
Cy_simulador.loop([Csun, Cearth, Cvenus])
tiempoCy = time.time() - inicio

speedUp = round(tiempoPy/tiempoCy,3)

print("Tiempo Python: {} \n".format(tiempoPy))
print("Tiempo Cython: {} \n".format(tiempoCy))
print("SpeedUp: {} \n".format(speedUp))