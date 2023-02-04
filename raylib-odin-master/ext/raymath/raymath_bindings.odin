
//
// THIS FILE WAS AUTOGENERATED
//

package raymath_bindings

foreign import raymath_native "raymath.lib"

import _c "core:c"
import "../../raylib/types"


import raymath_types "./types"

raymath_Funcs :: raymath_types.raymath_Funcs;

// re-export everything from ./types for convienience
RAYMATH_H :: raymath_types.RAYMATH_H;


Float3 :: raymath_types.Float3;
Float16 :: raymath_types.Float16;

get_function_pointers :: proc(funcs: ^raymath_types.raymath_Funcs) {
    funcs.clamp = clamp;
    funcs.lerp = lerp;
    funcs.vector2_zero = vector2_zero;
    funcs.vector2_one = vector2_one;
    funcs.vector2_add = vector2_add;
    funcs.vector2_subtract = vector2_subtract;
    funcs.vector2_length = vector2_length;
    funcs.vector2_dot_product = vector2_dot_product;
    funcs.vector2_distance = vector2_distance;
    funcs.vector2_angle = vector2_angle;
    funcs.vector2_scale = vector2_scale;
    funcs.vector2_multiply_v = vector2_multiply_v;
    funcs.vector2_negate = vector2_negate;
    funcs.vector2_divide = vector2_divide;
    funcs.vector2_divide_v = vector2_divide_v;
    funcs.vector2_normalize = vector2_normalize;
    funcs.vector2_lerp = vector2_lerp;
    funcs.vector3_zero = vector3_zero;
    funcs.vector3_one = vector3_one;
    funcs.vector3_add = vector3_add;
    funcs.vector3_subtract = vector3_subtract;
    funcs.vector3_multiply = vector3_multiply;
    funcs.vector3_multiply_v = vector3_multiply_v;
    funcs.vector3_cross_product = vector3_cross_product;
    funcs.vector3_perpendicular = vector3_perpendicular;
    funcs.vector3_length = vector3_length;
    funcs.vector3_dot_product = vector3_dot_product;
    funcs.vector3_distance = vector3_distance;
    funcs.vector3_scale = vector3_scale;
    funcs.vector3_negate = vector3_negate;
    funcs.vector3_divide = vector3_divide;
    funcs.vector3_divide_v = vector3_divide_v;
    funcs.vector3_normalize = vector3_normalize;
    funcs.vector3_ortho_normalize = vector3_ortho_normalize;
    funcs.vector3_transform = vector3_transform;
    funcs.vector3_rotate_by_quaternion = vector3_rotate_by_quaternion;
    funcs.vector3_lerp = vector3_lerp;
    funcs.vector3_reflect = vector3_reflect;
    funcs.vector3_min = vector3_min;
    funcs.vector3_max = vector3_max;
    funcs.vector3_barycenter = vector3_barycenter;
    funcs.vector3_to_float_v = vector3_to_float_v;
    funcs.matrix_determinant = matrix_determinant;
    funcs.matrix_trace = matrix_trace;
    funcs.matrix_transpose = matrix_transpose;
    funcs.matrix_invert = matrix_invert;
    funcs.matrix_normalize = matrix_normalize;
    funcs.matrix_identity = matrix_identity;
    funcs.matrix_add = matrix_add;
    funcs.matrix_subtract = matrix_subtract;
    funcs.matrix_translate = matrix_translate;
    funcs.matrix_rotate = matrix_rotate;
    funcs.matrix_rotate_x = matrix_rotate_x;
    funcs.matrix_rotate_y = matrix_rotate_y;
    funcs.matrix_rotate_z = matrix_rotate_z;
    funcs.matrix_scale = matrix_scale;
    funcs.matrix_multiply = matrix_multiply;
    funcs.matrix_frustum = matrix_frustum;
    funcs.matrix_perspective = matrix_perspective;
    funcs.matrix_ortho = matrix_ortho;
    funcs.matrix_look_at = matrix_look_at;
    funcs.matrix_to_float_v = matrix_to_float_v;
    funcs.quaternion_identity = quaternion_identity;
    funcs.quaternion_length = quaternion_length;
    funcs.quaternion_normalize = quaternion_normalize;
    funcs.quaternion_invert = quaternion_invert;
    funcs.quaternion_multiply = quaternion_multiply;
    funcs.quaternion_lerp = quaternion_lerp;
    funcs.quaternion_nlerp = quaternion_nlerp;
    funcs.quaternion_slerp = quaternion_slerp;
    funcs.quaternion_from_vector3_to_vector3 = quaternion_from_vector3_to_vector3;
    funcs.quaternion_from_matrix = quaternion_from_matrix;
    funcs.quaternion_to_matrix = quaternion_to_matrix;
    funcs.quaternion_from_axis_angle = quaternion_from_axis_angle;
    funcs.quaternion_to_axis_angle = quaternion_to_axis_angle;
    funcs.quaternion_from_euler = quaternion_from_euler;
    funcs.quaternion_to_euler = quaternion_to_euler;
    funcs.quaternion_transform = quaternion_transform;
}

@(default_calling_convention="c")
foreign raymath_native {

    @(link_name="Clamp")
    clamp :: proc(
        value : _c.float,
        min : _c.float,
        max : _c.float
    ) -> _c.float ---;

    @(link_name="Lerp")
    lerp :: proc(
        start : _c.float,
        end : _c.float,
        amount : _c.float
    ) -> _c.float ---;

    @(link_name="Vector2Zero")
    vector2_zero :: proc() -> Vector2 ---;

    @(link_name="Vector2One")
    vector2_one :: proc() -> Vector2 ---;

    @(link_name="Vector2Add")
    vector2_add :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> Vector2 ---;

    @(link_name="Vector2Subtract")
    vector2_subtract :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> Vector2 ---;

    @(link_name="Vector2Length")
    vector2_length :: proc(v : Vector2) -> _c.float ---;

    @(link_name="Vector2DotProduct")
    vector2_dot_product :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> _c.float ---;

    @(link_name="Vector2Distance")
    vector2_distance :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> _c.float ---;

    @(link_name="Vector2Angle")
    vector2_angle :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> _c.float ---;

    @(link_name="Vector2Scale")
    vector2_scale :: proc(
        v : Vector2,
        scale : _c.float
    ) -> Vector2 ---;

    @(link_name="Vector2MultiplyV")
    vector2_multiply_v :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> Vector2 ---;

    @(link_name="Vector2Negate")
    vector2_negate :: proc(v : Vector2) -> Vector2 ---;

    @(link_name="Vector2Divide")
    vector2_divide :: proc(
        v : Vector2,
        div : _c.float
    ) -> Vector2 ---;

    @(link_name="Vector2DivideV")
    vector2_divide_v :: proc(
        v1 : Vector2,
        v2 : Vector2
    ) -> Vector2 ---;

    @(link_name="Vector2Normalize")
    vector2_normalize :: proc(v : Vector2) -> Vector2 ---;

    @(link_name="Vector2Lerp")
    vector2_lerp :: proc(
        v1 : Vector2,
        v2 : Vector2,
        amount : _c.float
    ) -> Vector2 ---;

    @(link_name="Vector3Zero")
    vector3_zero :: proc() -> Vector3 ---;

    @(link_name="Vector3One")
    vector3_one :: proc() -> Vector3 ---;

    @(link_name="Vector3Add")
    vector3_add :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Subtract")
    vector3_subtract :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Multiply")
    vector3_multiply :: proc(
        v : Vector3,
        scalar : _c.float
    ) -> Vector3 ---;

    @(link_name="Vector3MultiplyV")
    vector3_multiply_v :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3CrossProduct")
    vector3_cross_product :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Perpendicular")
    vector3_perpendicular :: proc(v : Vector3) -> Vector3 ---;

    @(link_name="Vector3Length")
    vector3_length :: proc(v : Vector3) -> _c.float ---;

    @(link_name="Vector3DotProduct")
    vector3_dot_product :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> _c.float ---;

    @(link_name="Vector3Distance")
    vector3_distance :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> _c.float ---;

    @(link_name="Vector3Scale")
    vector3_scale :: proc(
        v : Vector3,
        scale : _c.float
    ) -> Vector3 ---;

    @(link_name="Vector3Negate")
    vector3_negate :: proc(v : Vector3) -> Vector3 ---;

    @(link_name="Vector3Divide")
    vector3_divide :: proc(
        v : Vector3,
        div : _c.float
    ) -> Vector3 ---;

    @(link_name="Vector3DivideV")
    vector3_divide_v :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Normalize")
    vector3_normalize :: proc(v : Vector3) -> Vector3 ---;

    @(link_name="Vector3OrthoNormalize")
    vector3_ortho_normalize :: proc(
        v1 : ^Vector3,
        v2 : ^Vector3
    ) ---;

    @(link_name="Vector3Transform")
    vector3_transform :: proc(
        v : Vector3,
        mat : Matrix
    ) -> Vector3 ---;

    @(link_name="Vector3RotateByQuaternion")
    vector3_rotate_by_quaternion :: proc(
        v : Vector3,
        q : Quaternion
    ) -> Vector3 ---;

    @(link_name="Vector3Lerp")
    vector3_lerp :: proc(
        v1 : Vector3,
        v2 : Vector3,
        amount : _c.float
    ) -> Vector3 ---;

    @(link_name="Vector3Reflect")
    vector3_reflect :: proc(
        v : Vector3,
        normal : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Min")
    vector3_min :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Max")
    vector3_max :: proc(
        v1 : Vector3,
        v2 : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3Barycenter")
    vector3_barycenter :: proc(
        p : Vector3,
        a : Vector3,
        b : Vector3,
        c : Vector3
    ) -> Vector3 ---;

    @(link_name="Vector3ToFloatV")
    vector3_to_float_v :: proc(v : Vector3) -> Float3 ---;

    @(link_name="MatrixDeterminant")
    matrix_determinant :: proc(mat : Matrix) -> _c.float ---;

    @(link_name="MatrixTrace")
    matrix_trace :: proc(mat : Matrix) -> _c.float ---;

    @(link_name="MatrixTranspose")
    matrix_transpose :: proc(mat : Matrix) -> Matrix ---;

    @(link_name="MatrixInvert")
    matrix_invert :: proc(mat : Matrix) -> Matrix ---;

    @(link_name="MatrixNormalize")
    matrix_normalize :: proc(mat : Matrix) -> Matrix ---;

    @(link_name="MatrixIdentity")
    matrix_identity :: proc() -> Matrix ---;

    @(link_name="MatrixAdd")
    matrix_add :: proc(
        left : Matrix,
        right : Matrix
    ) -> Matrix ---;

    @(link_name="MatrixSubtract")
    matrix_subtract :: proc(
        left : Matrix,
        right : Matrix
    ) -> Matrix ---;

    @(link_name="MatrixTranslate")
    matrix_translate :: proc(
        x : _c.float,
        y : _c.float,
        z : _c.float
    ) -> Matrix ---;

    @(link_name="MatrixRotate")
    matrix_rotate :: proc(
        axis : Vector3,
        angle : _c.float
    ) -> Matrix ---;

    @(link_name="MatrixRotateX")
    matrix_rotate_x :: proc(angle : _c.float) -> Matrix ---;

    @(link_name="MatrixRotateY")
    matrix_rotate_y :: proc(angle : _c.float) -> Matrix ---;

    @(link_name="MatrixRotateZ")
    matrix_rotate_z :: proc(angle : _c.float) -> Matrix ---;

    @(link_name="MatrixScale")
    matrix_scale :: proc(
        x : _c.float,
        y : _c.float,
        z : _c.float
    ) -> Matrix ---;

    @(link_name="MatrixMultiply")
    matrix_multiply :: proc(
        left : Matrix,
        right : Matrix
    ) -> Matrix ---;

    @(link_name="MatrixFrustum")
    matrix_frustum :: proc(
        left : _c.double,
        right : _c.double,
        bottom : _c.double,
        top : _c.double,
        near : _c.double,
        far : _c.double
    ) -> Matrix ---;

    @(link_name="MatrixPerspective")
    matrix_perspective :: proc(
        fovy : _c.double,
        aspect : _c.double,
        near : _c.double,
        far : _c.double
    ) -> Matrix ---;

    @(link_name="MatrixOrtho")
    matrix_ortho :: proc(
        left : _c.double,
        right : _c.double,
        bottom : _c.double,
        top : _c.double,
        near : _c.double,
        far : _c.double
    ) -> Matrix ---;

    @(link_name="MatrixLookAt")
    matrix_look_at :: proc(
        eye : Vector3,
        target : Vector3,
        up : Vector3
    ) -> Matrix ---;

    @(link_name="MatrixToFloatV")
    matrix_to_float_v :: proc(mat : Matrix) -> Float16 ---;

    @(link_name="QuaternionIdentity")
    quaternion_identity :: proc() -> Quaternion ---;

    @(link_name="QuaternionLength")
    quaternion_length :: proc(q : Quaternion) -> _c.float ---;

    @(link_name="QuaternionNormalize")
    quaternion_normalize :: proc(q : Quaternion) -> Quaternion ---;

    @(link_name="QuaternionInvert")
    quaternion_invert :: proc(q : Quaternion) -> Quaternion ---;

    @(link_name="QuaternionMultiply")
    quaternion_multiply :: proc(
        q1 : Quaternion,
        q2 : Quaternion
    ) -> Quaternion ---;

    @(link_name="QuaternionLerp")
    quaternion_lerp :: proc(
        q1 : Quaternion,
        q2 : Quaternion,
        amount : _c.float
    ) -> Quaternion ---;

    @(link_name="QuaternionNlerp")
    quaternion_nlerp :: proc(
        q1 : Quaternion,
        q2 : Quaternion,
        amount : _c.float
    ) -> Quaternion ---;

    @(link_name="QuaternionSlerp")
    quaternion_slerp :: proc(
        q1 : Quaternion,
        q2 : Quaternion,
        amount : _c.float
    ) -> Quaternion ---;

    @(link_name="QuaternionFromVector3ToVector3")
    quaternion_from_vector3_to_vector3 :: proc(
        from : Vector3,
        to : Vector3
    ) -> Quaternion ---;

    @(link_name="QuaternionFromMatrix")
    quaternion_from_matrix :: proc(mat : Matrix) -> Quaternion ---;

    @(link_name="QuaternionToMatrix")
    quaternion_to_matrix :: proc(q : Quaternion) -> Matrix ---;

    @(link_name="QuaternionFromAxisAngle")
    quaternion_from_axis_angle :: proc(
        axis : Vector3,
        angle : _c.float
    ) -> Quaternion ---;

    @(link_name="QuaternionToAxisAngle")
    quaternion_to_axis_angle :: proc(
        q : Quaternion,
        out_axis : ^Vector3,
        out_angle : ^_c.float
    ) ---;

    @(link_name="QuaternionFromEuler")
    quaternion_from_euler :: proc(
        roll : _c.float,
        pitch : _c.float,
        yaw : _c.float
    ) -> Quaternion ---;

    @(link_name="QuaternionToEuler")
    quaternion_to_euler :: proc(q : Quaternion) -> Vector3 ---;

    @(link_name="QuaternionTransform")
    quaternion_transform :: proc(
        q : Quaternion,
        mat : Matrix
    ) -> Quaternion ---;

}
