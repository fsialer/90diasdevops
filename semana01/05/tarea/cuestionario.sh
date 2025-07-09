#!/bin/bash

echo "🎉 ¡Bienvenido al Cuestionario Loco! 🎉"

# Preguntar nombre
echo -n "💬 ¿Cuál es tu nombre?: "
read nombre

# Preguntar edad
echo -n "🕒 ¿Cuántos años tenés?: "
read edad

# Preguntar color favorito
echo -n "🎨 ¿Cuál es tu color favorito?: "
read color

# Mensaje personalizado
echo "🔍 Analizando tus respuestas, $nombre... 🧠"

# Respuesta según edad
if [ "$edad" -lt 18 ]; then
  echo "🧒 Sos menor de edad. ¡A disfrutar la juventud, $nombre! 🚀"
elif [ "$edad" -ge 18 ] && [ "$edad" -lt 60 ]; then
  echo "🧑 Sos adulto. ¡A seguir rompiéndola, $nombre! 💪"
else
  echo "👴 Sos una persona con mucha experiencia. ¡Sabiduría pura, $nombre! 📚"
fi

# Respuesta según color
if [ "$color" == "rojo" ]; then
  echo "🔥 El rojo es pasión. Sos una persona intensa, $nombre. 💥"
elif [ "$color" == "azul" ]; then
  echo "🌊 El azul transmite calma. Seguro sos muy tranquilo, $nombre. 🧘"
elif [ "$color" == "verde" ]; then
  echo "🍃 Amás la naturaleza. ¡Un ser eco-friendly! 🌍"
else
  echo "🌈 Wow, el color $color no es tan común. ¡Originalidad total! 🤩"
fi

echo "✅ ¡Gracias por jugar al cuestionario loco, $nombre! 🎊"