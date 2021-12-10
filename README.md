## Configuration for archive note: Build Hololens 2.0 with Unity MR Toolkit 
- Unity 2020.3.12 f1
- MixedRealityToolkit: [Microsoft.MixedReality.Toolkit.Unity.Foundation.2.7.2.unitypackage](https://github.com/Microsoft/MixedRealityToolkit-Unity/releases)


## Scene Composition
- Unlike Unity AR, which sets up each scene in different Unity Scene files, Hololens MR requires you to put all assets in one scene. So it doesn't need to keep changing the scene depends on the marker image. Or that's how we did it to prevent bugs/overloads.
- The angles of where the model pops up (compares to the angle of marker image location) works almost same to AR version
- Shader URP and lighting and sound work okay. Touch & emit the particles interaction is not working great on MR. 
![scene1](imagesReadMe/1.jpg)
![scene2](imagesReadMe/2.jpg)

- MixedRealityToolkit configuration: you can clone and create a new profile, name it as 'MyMixedRealityRegisteredServiceProvidersProfile' and use that in config setting.
![vuforia profile setting1](imagesReadMe/3.jpg)
![vuforia profile setting2](imagesReadMe/4.jpg)
![vuforia profile setting3](imagesReadMe/5.jpg)
![vuforia profile setting4](imagesReadMe/6.jpg)
- (I think...) You don't need Vuforia engine unless you want to recognize the 3d object in real life and augment sth in your MR hololens.
![profile setting1](imagesReadMe/8.jpg)
![profile setting2](imagesReadMe/9.jpg)
![profile setting3](imagesReadMe/10.jpg)
![profile setting4](imagesReadMe/11.jpg)
![profile setting5](imagesReadMe/12.jpg)
![profile setting6](imagesReadMe/13.jpg)
![profile setting7](imagesReadMe/14.jpg)

### Manager Scene, Scene Loader
- Here, we used 'Manager Scene' in 'Scene system' of MRTK. 
- Then, added the actual MR playing scene in `Scene Loader` game object with `LoadContentScene` code. 
- XreaManage Scene contains `MixedRealityPlayspace` which is an empty object but has `main camera` as an only child, `MixedRealityToolkit` which includes configuration, `SceneLoader` which loads our main player scene (`XreaImageTarget` that has all assets for augmentation)
![mixed reality playspace camera](imagesReadMe/scene1.png)
![Mixed reality toolkit](imagesReadMe/scene2.png)
![Scene Loader](imagesReadMe/scene3.png)
![Main scene for play](imagesReadMe/scene4.png)

- The screenshot below is the scene configuration of sample scene that mentor built it as a test for interaction.
- It's a bit different from our MR main scene. This example below has its own main camera where as our main MR Play scene gets loaded by Manager component.
![profile setting8](imagesReadMe/15.jpg)

#### Target Images 
- The image size has to be in exact unit. Otherwise, it might cause the augmented models position/angle bit off. 
- I had to change 100 to 75 for accurate recognition.
![target images](imagesReadMe/16.jpg)

### Package, Build
![package manager list](imagesReadMe/17.png)
![Universal Windows Platform Hololens for Build setting](imagesReadMe/18.png)

