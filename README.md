## External libs for IDEA
clone https://github.com/EmmyLua/Emmy-love-api and attach to IDEA 
    as external library for autocompletes
    
## Particles
```
moveTo - двигаться к x, y
pause - остановить выбрасывание частиц
reset - удалить выпущенные частицы и сбросить таймер жизни
setEmissionArea - спавнить только в определенной зоне. args(uniform|normal|ellipse|borderellipse|borderrectangle, отклонение x, отклонение y, угол, directionRelativeToCenter)
setBufferSize - кол-во частиц, существующих единовременно
setColors( r1, g1, b1, a1, r2, g2, b2, a2, ..., r8, g8, b8, a8 ) - диапазон цветов
setDirection(radians) - направление частиц в радианах
setEmissionRate(rate) - частиц в сек
setEmitterLifetime(sec) - время жизни эмитера
setInsertMode(top|bottom|random) - размещение новых частиц на z-оси
setLinearAcceleration( xmin, ymin, xmax, ymax ) - скорость частиц (направление вперед, назад)
setLinearDamping( min, max ) - замедление
setOffset( x, y )
setParticleLifetime( min sec, max sec )
setPosition( x, y )
setQuads( quad1, quad2, ... ) - используется для анимации. квады - это фигуры, которые будет менять частица со временем
setRelativeRotation
setRotation( min rad, max rad )
setSizeVariation
setSizes( size1, size2, ..., size8 )
setSpeed( min, max )
setSpin( min, max )
setSpinVariation( variation )
setSpread( spread radians )
start
stop
```