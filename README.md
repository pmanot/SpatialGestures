
<img align=top src="/Assets/logo.png" width=100 height=auto>

# Spatial Gestures

Spatial Gestures brings the finger gesture recognition capabilities from the [Apple Vision Pro](https://www.apple.com/apple-vision-pro) to macOS without any external hardware. The framework uses the builtin webcam for detecting hand and finger movements, providing a stream of high level gestures and projected coordinates which can be observed and used as input for associated actions.

### Supported Gestures
The API provides first class support for the basic gestures available in visionOS:
| Pinch to Tap | Rotate & Scale | Drag |
| -------- | ------- | ------- |
| <img align=center src="/Assets/pinch.png" width=auto height=auto> | <img align=center src="/Assets/rotate.png" width=auto height=auto> | <img align=center src="/Assets/drag.png" width=auto height=auto> |

### Known Limitations
Due to the lack of dedicated sensors, the recognized gesture values can sometimes be incorrect - especially in low light conditions or weird camera angles. 
