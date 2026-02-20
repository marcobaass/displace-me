import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import GUI from 'lil-gui'
import vertexShader from './shaders/text/vertexShader.glsl?raw'
import vertexShaderShadow from './shaders/shadow/vertexShader.glsl?raw'
import fragmentShader from './shaders/text/fragmentShader.glsl?raw'
import fragmentShadowShader from './shaders/shadow/fragmentShader.glsl?raw'

/**
 * Base
 */
// Debug
const gui = new GUI()

// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()

/**
 * Geometry and Material
 */
// Plane
const planeGeometry = new THREE.PlaneGeometry(10, 10, 100, 100)

// PlaneMaterial
const planeMaterial = new THREE.ShaderMaterial({
  vertexShader,
  fragmentShader,

  uniforms: {
    uTexture: { value: new THREE.TextureLoader().load('/textures/displaceFull.png') },
    uDisplacement: { value: new THREE.Vector3(0, 0, 0) },
    uContentSize: { value: new THREE.Vector2(1.0, 1.0) },
    uTime: { value: 0 }
  },

  transparent: true,
  depthWrite: false,
  side: THREE.DoubleSide

})

const planeMesh = new THREE.Mesh(planeGeometry, planeMaterial)

planeMesh.rotation.z = Math.PI / 4

scene.add(planeMesh)

// Shadow Plane
const shadowPlaneGeometry = new THREE.PlaneGeometry(10, 10, 100, 100)

const shadowPlaneMaterial = new THREE.ShaderMaterial({
  vertexShader: vertexShaderShadow,
  fragmentShader: fragmentShadowShader,

  uniforms: {
    uShadowTexture: { value: new THREE.TextureLoader().load('/textures/displaceShadow.png') },
    uDisplacement: { value: new THREE.Vector3(0, 0, 0) },
    uShadowContentSize: { value: new THREE.Vector2(1.0, 1.0) },
    uBlurRadius: { value: 0.02 }
  },

  transparent: true,
  side: THREE.DoubleSide

})

const shadowPlaneMesh = new THREE.Mesh(shadowPlaneGeometry, shadowPlaneMaterial)

shadowPlaneMaterial.depthWrite = false;
shadowPlaneMesh.rotation.z = Math.PI / 4

scene.add(shadowPlaneMesh)

// Sphere
const sphereGeometry = new THREE.SphereGeometry(0.02, 16, 16)
const sphereMaterial = new THREE.MeshBasicMaterial({color: 0x00ff00})
const sphereMesh = new THREE.Mesh(sphereGeometry, sphereMaterial)
scene.add(sphereMesh)

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const aspectRatio = sizes.width / sizes.height
const camera = new THREE.OrthographicCamera(-aspectRatio, aspectRatio, 1, -1, 0.1, 100)
camera.position.set(-0, -10, 5)
camera.lookAt(0,0,0)
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

/**
 * Raycaster
 */

const raycaster = new THREE.Raycaster();
const pointer = new THREE.Vector2();

window.addEventListener('pointermove', onPointerMove)

function onPointerMove(e) {  
  pointer.x = (e.clientX / window.innerWidth) * 2 - 1;
  pointer.y = -(e.clientY / window.innerHeight) * 2 + 1;

  raycaster.setFromCamera(pointer, camera);
  const intersects = raycaster.intersectObject(planeMesh);

  if (intersects.length > 0) {
    sphereMesh.position.copy(intersects[0].point);

    const localPoint = planeMesh.worldToLocal(intersects[0].point.clone());
    
    planeMaterial.uniforms.uDisplacement.value.copy(localPoint);
    shadowPlaneMaterial.uniforms.uDisplacement.value.copy(localPoint);
  }

}

/**
 * Tweaks
 */

gui.add(shadowPlaneMaterial.uniforms.uBlurRadius, 'value').min(0).max(0.1).step(0.001).name('Blur Radius')

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

renderer.setClearColor(0xffffff, 1)

/**
 * Animate
 */
const clock = new THREE.Clock()

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()

    // Update controls
    controls.update()

    // update time
    planeMaterial.uniforms.uTime.value = elapsedTime;

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()
