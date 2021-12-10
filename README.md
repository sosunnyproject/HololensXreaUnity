## Configuration for archive note: Build Hololens 2.0 with Unity MR Toolkit 
- Unity 2020.3.12 f1
- MixedRealityToolkit: [Microsoft.MixedReality.Toolkit.Unity.Foundation.2.7.2.unitypackage](https://github.com/Microsoft/MixedRealityToolkit-Unity/releases)


## Scene Composition
- Unlike Unity AR, which sets up each scene in different Unity Scene files, Hololens MR requires you to put all assets in one scene. So it doesn't need to keep changing the scene depends on the marker image. Or that's how we did it to prevent bugs/overloads.
- The angles of where the model pops up (compares to the angle of marker image location) works almost same to AR version
- Shader URP and lighting and sound work okay. Touch & emit the particles interaction is not working great on MR. 


- The image size has to be in exact unit. Otherwise, it might cause the augmented models position/angle bit off.


- (I think...) You don't need Vuforia engine unless you want to recognize the 3d object in real life and augment sth in your MR hololens.
- MixedRealityToolkit configuration: you can clone and create a new profile, name it as 'MyMixedRealityRegisteredServiceProvidersProfile' and use that in config setting.


- Here, we used 'Manager Scene' in 'Scene system' of MRTK. 
- Then, added the actual MR playing scene in `Scene Loader` game object with `LoadContentScene` code. 
