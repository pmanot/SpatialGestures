
<img align=top src="/Assets/logo.png" width=100 height=auto>

# Spatial Gestures

Spatial Gestures brings the finger gesture recognition capabilities of the new Apple Vision Pro headset to macOS without any external hardware. The framework uses the builtin webcam for detecting hand and finger movements, providing a stream of high level gestures and projected coordinates which can be observed and used as input for associated actions.

### Supported Gestures
The API provides first class support for the basic gestures available in visionOS:
| Pinch to Tap | Rotate & Scale | Drag |
| -------- | ------- | ------- |
| <img align=center src="https://github.com/pmanot/SpatialGestures/assets/60108184/52c7ed17-652e-45d5-8610-245a6e4574bb" width=auto height=auto> | <img align=center src="https://github.com/pmanot/SpatialGestures/assets/60108184/90a5be1a-cbe3-4586-a9cd-e18792671f4e" width=auto height=auto> | <img align=center src="https://github.com/pmanot/SpatialGestures/assets/60108184/88776cf9-1bed-4484-8f00-e510c5b2b52b" width=auto height=auto> |

### Known Limitations
Due to the lack of dedicated sensors, the recognized gesture values can sometimes be incorrect - especially in low light conditions or weird camera angles. 
