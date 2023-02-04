
//
// THIS FILE WAS AUTOGENERATED
//

package physac_bindings

foreign import physac_native "physac.lib"

import _c "core:c"
import "../../raylib/types"


import physac_types "./types"

physac_Funcs :: physac_types.physac_Funcs;

// re-export everything from ./types for convienience
PHYSAC_H :: physac_types.PHYSAC_H;
PHYSAC_MAX_BODIES :: physac_types.PHYSAC_MAX_BODIES;
PHYSAC_MAX_MANIFOLDS :: physac_types.PHYSAC_MAX_MANIFOLDS;
PHYSAC_MAX_VERTICES :: physac_types.PHYSAC_MAX_VERTICES;
PHYSAC_CIRCLE_VERTICES :: physac_types.PHYSAC_CIRCLE_VERTICES;
PHYSAC_DESIRED_DELTATIME :: physac_types.PHYSAC_DESIRED_DELTATIME;
PHYSAC_MAX_TIMESTEP :: physac_types.PHYSAC_MAX_TIMESTEP;
PHYSAC_COLLISION_ITERATIONS :: physac_types.PHYSAC_COLLISION_ITERATIONS;
PHYSAC_PENETRATION_ALLOWANCE :: physac_types.PHYSAC_PENETRATION_ALLOWANCE;
PHYSAC_PENETRATION_CORRECTION :: physac_types.PHYSAC_PENETRATION_CORRECTION;
PHYSAC_PI :: physac_types.PHYSAC_PI;
PHYSAC_DEG2RAD :: physac_types.PHYSAC_DEG2RAD;

PhysicsBody :: physac_types.PhysicsBody;

PhysicsBodyData :: physac_types.PhysicsBodyData;
Mat2 :: physac_types.Mat2;
PolygonData :: physac_types.PolygonData;
PhysicsShape :: physac_types.PhysicsShape;
PhysicsManifoldData :: physac_types.PhysicsManifoldData;
PhysicsShapeType :: physac_types.PhysicsShapeType;

get_function_pointers :: proc(funcs: ^physac_types.physac_Funcs) {
    funcs.init_physics = init_physics;
    funcs.is_physics_enabled = is_physics_enabled;
    funcs.set_physics_gravity = set_physics_gravity;
    funcs.create_physics_body_circle = create_physics_body_circle;
    funcs.create_physics_body_rectangle = create_physics_body_rectangle;
    funcs.create_physics_body_polygon = create_physics_body_polygon;
    funcs.physics_add_force = physics_add_force;
    funcs.physics_add_torque = physics_add_torque;
    funcs.physics_shatter = physics_shatter;
    funcs.get_physics_bodies_count = get_physics_bodies_count;
    funcs.get_physics_body = get_physics_body;
    funcs.get_physics_shape_type = get_physics_shape_type;
    funcs.get_physics_shape_vertices_count = get_physics_shape_vertices_count;
    funcs.get_physics_shape_vertex = get_physics_shape_vertex;
    funcs.set_physics_body_rotation = set_physics_body_rotation;
    funcs.destroy_physics_body = destroy_physics_body;
    funcs.reset_physics = reset_physics;
    funcs.close_physics = close_physics;
    funcs.physics_loop = physics_loop;
}

@(default_calling_convention="c")
foreign physac_native {

    @(link_name="InitPhysics")
    init_physics :: proc() ---;

    @(link_name="IsPhysicsEnabled")
    is_physics_enabled :: proc() -> bool ---;

    @(link_name="SetPhysicsGravity")
    set_physics_gravity :: proc(
        x : _c.float,
        y : _c.float
    ) ---;

    @(link_name="CreatePhysicsBodyCircle")
    create_physics_body_circle :: proc(
        pos : Vector2,
        radius : _c.float,
        density : _c.float
    ) -> PhysicsBody ---;

    @(link_name="CreatePhysicsBodyRectangle")
    create_physics_body_rectangle :: proc(
        pos : Vector2,
        width : _c.float,
        height : _c.float,
        density : _c.float
    ) -> PhysicsBody ---;

    @(link_name="CreatePhysicsBodyPolygon")
    create_physics_body_polygon :: proc(
        pos : Vector2,
        radius : _c.float,
        sides : _c.int,
        density : _c.float
    ) -> PhysicsBody ---;

    @(link_name="PhysicsAddForce")
    physics_add_force :: proc(
        body : PhysicsBody,
        force : Vector2
    ) ---;

    @(link_name="PhysicsAddTorque")
    physics_add_torque :: proc(
        body : PhysicsBody,
        amount : _c.float
    ) ---;

    @(link_name="PhysicsShatter")
    physics_shatter :: proc(
        body : PhysicsBody,
        position : Vector2,
        force : _c.float
    ) ---;

    @(link_name="GetPhysicsBodiesCount")
    get_physics_bodies_count :: proc() -> _c.int ---;

    @(link_name="GetPhysicsBody")
    get_physics_body :: proc(index : _c.int) -> PhysicsBody ---;

    @(link_name="GetPhysicsShapeType")
    get_physics_shape_type :: proc(index : _c.int) -> _c.int ---;

    @(link_name="GetPhysicsShapeVerticesCount")
    get_physics_shape_vertices_count :: proc(index : _c.int) -> _c.int ---;

    @(link_name="GetPhysicsShapeVertex")
    get_physics_shape_vertex :: proc(
        body : PhysicsBody,
        vertex : _c.int
    ) -> Vector2 ---;

    @(link_name="SetPhysicsBodyRotation")
    set_physics_body_rotation :: proc(
        body : PhysicsBody,
        radians : _c.float
    ) ---;

    @(link_name="DestroyPhysicsBody")
    destroy_physics_body :: proc(body : PhysicsBody) ---;

    @(link_name="ResetPhysics")
    reset_physics :: proc() ---;

    @(link_name="ClosePhysics")
    close_physics :: proc() ---;

    @(link_name="PhysicsLoop")
    physics_loop :: proc(data : rawptr) -> rawptr ---;

}
