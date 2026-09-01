#pragma once

#include <wayland-client.h>
#include <wayland-client-core.h>
#include <wayland-client-protocol.h>

#include <wayland-server.h>
#include <wayland-server-core.h>
#include <wayland-server-protocol.h>

#include <wayland-egl.h>
#include <wayland-egl-backend.h>
#include <wayland-egl-core.h>

#include <wayland-cursor.h>
#include <wayland-util.h>
#include <wayland-version.h>

#include <wayland-protocols/alpha-modifier-v1-enum.h>
#include <wayland-protocols/color-management-v1-enum.h>
#include <wayland-protocols/color-representation-v1-enum.h>
#include <wayland-protocols/commit-timing-v1-enum.h>
#include <wayland-protocols/content-type-v1-enum.h>
#include <wayland-protocols/cursor-shape-v1-enum.h>
#include <wayland-protocols/drm-lease-v1-enum.h>
#include <wayland-protocols/ext-background-effect-v1-enum.h>
#include <wayland-protocols/ext-data-control-v1-enum.h>
#include <wayland-protocols/ext-foreign-toplevel-list-v1-enum.h>
#include <wayland-protocols/ext-idle-notify-v1-enum.h>
#include <wayland-protocols/ext-image-capture-source-v1-enum.h>
#include <wayland-protocols/ext-image-copy-capture-v1-enum.h>
#include <wayland-protocols/ext-session-lock-v1-enum.h>
#include <wayland-protocols/ext-transient-seat-v1-enum.h>
#include <wayland-protocols/ext-workspace-v1-enum.h>
#include <wayland-protocols/fifo-v1-enum.h>
#include <wayland-protocols/fractional-scale-v1-enum.h>
#include <wayland-protocols/fullscreen-shell-unstable-v1-enum.h>
#include <wayland-protocols/idle-inhibit-unstable-v1-enum.h>
#include <wayland-protocols/input-method-unstable-v1-enum.h>
#include <wayland-protocols/input-timestamps-unstable-v1-enum.h>
#include <wayland-protocols/keyboard-shortcuts-inhibit-unstable-v1-enum.h>
#include <wayland-protocols/linux-dmabuf-unstable-v1-enum.h>
#include <wayland-protocols/linux-dmabuf-v1-enum.h>
#include <wayland-protocols/linux-drm-syncobj-v1-enum.h>
#include <wayland-protocols/linux-explicit-synchronization-unstable-v1-enum.h>
#include <wayland-protocols/pointer-constraints-unstable-v1-enum.h>
#include <wayland-protocols/pointer-gestures-unstable-v1-enum.h>
#include <wayland-protocols/pointer-warp-v1-enum.h>
#include <wayland-protocols/presentation-time-enum.h>
#include <wayland-protocols/primary-selection-unstable-v1-enum.h>
#include <wayland-protocols/relative-pointer-unstable-v1-enum.h>
#include <wayland-protocols/security-context-v1-enum.h>
#include <wayland-protocols/single-pixel-buffer-v1-enum.h>
#include <wayland-protocols/tablet-unstable-v1-enum.h>
#include <wayland-protocols/tablet-unstable-v2-enum.h>
#include <wayland-protocols/tablet-v2-enum.h>
#include <wayland-protocols/tearing-control-v1-enum.h>
#include <wayland-protocols/text-input-unstable-v1-enum.h>
#include <wayland-protocols/text-input-unstable-v3-enum.h>
#include <wayland-protocols/viewporter-enum.h>

#include <wayland-protocols/xdg-activation-v1-enum.h>
#include <wayland-protocols/xdg-decoration-unstable-v1-enum.h>
#include <wayland-protocols/xdg-dialog-v1-enum.h>
#include <wayland-protocols/xdg-foreign-unstable-v1-enum.h>
#include <wayland-protocols/xdg-foreign-unstable-v2-enum.h>
#include <wayland-protocols/xdg-output-unstable-v1-enum.h>
#include <wayland-protocols/xdg-session-management-v1-enum.h>
#include <wayland-protocols/xdg-shell-enum.h>
#include <wayland-protocols/xdg-shell-unstable-v5-enum.h>
#include <wayland-protocols/xdg-shell-unstable-v6-enum.h>
#include <wayland-protocols/xdg-system-bell-v1-enum.h>
#include <wayland-protocols/xdg-toplevel-drag-v1-enum.h>
#include <wayland-protocols/xdg-toplevel-icon-v1-enum.h>
#include <wayland-protocols/xdg-toplevel-tag-v1-enum.h>

#include <wayland-protocols/xwayland-keyboard-grab-unstable-v1-enum.h>
#include <wayland-protocols/xwayland-shell-v1-enum.h>

#include <wayland-protocols/xx-cutouts-v1-enum.h>
#include <wayland-protocols/xx-input-method-v2-enum.h>
#include <wayland-protocols/xx-keyboard-filter-v1-enum.h>
#include <wayland-protocols/xx-session-management-v1-enum.h>
#include <wayland-protocols/xx-text-input-v3-enum.h>
#include <wayland-protocols/xx-zones-v1-enum.h>

#include <xkbcommon/xkbcommon.h>
#include <stdlib.h>
#include <xkbcommon/xkbcommon-keysyms.h>
#include <libinput.h>



static inline const struct wl_interface *wl_swift_display_interface(void) { return &wl_display_interface; }
static inline const struct wl_interface *wl_swift_registry_interface(void) { return &wl_registry_interface; }
static inline const struct wl_interface *wl_swift_callback_interface(void) { return &wl_callback_interface; }
static inline const struct wl_interface *wl_swift_compositor_interface(void) { return &wl_compositor_interface; }
static inline const struct wl_interface *wl_swift_shm_pool_interface(void) { return &wl_shm_pool_interface; }
static inline const struct wl_interface *wl_swift_shm_interface(void) { return &wl_shm_interface; }
static inline const struct wl_interface *wl_swift_buffer_interface(void) { return &wl_buffer_interface; }
static inline const struct wl_interface *wl_swift_data_offer_interface(void) { return &wl_data_offer_interface; }
static inline const struct wl_interface *wl_swift_data_source_interface(void) { return &wl_data_source_interface; }
static inline const struct wl_interface *wl_swift_data_device_interface(void) { return &wl_data_device_interface; }
static inline const struct wl_interface *wl_swift_data_device_manager_interface(void) { return &wl_data_device_manager_interface; }
static inline const struct wl_interface *wl_swift_surface_interface(void) { return &wl_surface_interface; }
static inline const struct wl_interface *wl_swift_seat_interface(void) { return &wl_seat_interface; }
static inline const struct wl_interface *wl_swift_pointer_interface(void) { return &wl_pointer_interface; }
static inline const struct wl_interface *wl_swift_keyboard_interface(void) { return &wl_keyboard_interface; }
static inline const struct wl_interface *wl_swift_touch_interface(void) { return &wl_touch_interface; }
static inline const struct wl_interface *wl_swift_output_interface(void) { return &wl_output_interface; }
static inline const struct wl_interface *wl_swift_region_interface(void) { return &wl_region_interface; }

typedef void (*wl_swift_compositor_create_surface_func_t)(void *env, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_compositor_create_region_func_t)(void *env, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_compositor_release_func_t)(void *env, struct wl_client *client, struct wl_resource *resource);

struct wl_swift_compositor_env {
    void *swift_context;
    wl_swift_compositor_create_surface_func_t create_surface;
    wl_swift_compositor_create_region_func_t create_region;
    wl_swift_compositor_release_func_t release;
};

static void _wl_swift_compositor_create_surface(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_compositor_env *env = (struct wl_swift_compositor_env *)wl_resource_get_user_data(resource);
    if (env) env->create_surface(env->swift_context, client, resource, id);
}

static void _wl_swift_compositor_create_region(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_compositor_env *env = (struct wl_swift_compositor_env *)wl_resource_get_user_data(resource);
    if (env) env->create_region(env->swift_context, client, resource, id);
}

static void _wl_swift_compositor_release(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_compositor_env *env = (struct wl_swift_compositor_env *)wl_resource_get_user_data(resource);
    if (env) env->release(env->swift_context, client, resource);
}

static const struct wl_compositor_interface wl_swift_compositor_implementation = {
    .create_surface = _wl_swift_compositor_create_surface,
    .create_region = _wl_swift_compositor_create_region,
    .release = _wl_swift_compositor_release,
};

static void _wl_swift_compositor_destroy(struct wl_resource *resource) {
    struct wl_swift_compositor_env *env = (struct wl_swift_compositor_env *)wl_resource_get_user_data(resource);
    free(env);
}

static inline void wl_swift_set_compositor_implementation(
    struct wl_resource *resource,
    struct wl_swift_compositor_env *env)
{
    wl_resource_set_implementation(
        resource,
        &wl_swift_compositor_implementation,
        env,
        _wl_swift_compositor_destroy);
}

static inline void wl_swift_resource_post_error(
    struct wl_resource *resource, uint32_t code, const char *message)
{
    wl_resource_post_error(resource, code, "%s", message);
}

typedef void (*wl_swift_surface_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_surface_attach_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    struct wl_resource *buffer, int32_t x, int32_t y);
typedef void (*wl_swift_surface_damage_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    int32_t x, int32_t y, int32_t width, int32_t height);
typedef void (*wl_swift_surface_frame_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    uint32_t callback);
typedef void (*wl_swift_surface_set_opaque_region_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    struct wl_resource *region);
typedef void (*wl_swift_surface_set_input_region_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    struct wl_resource *region);
typedef void (*wl_swift_surface_commit_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_surface_set_buffer_transform_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    int32_t transform);
typedef void (*wl_swift_surface_set_buffer_scale_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    int32_t scale);
typedef void (*wl_swift_surface_damage_buffer_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    int32_t x, int32_t y, int32_t width, int32_t height);
typedef void (*wl_swift_surface_offset_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    int32_t x, int32_t y);

struct wl_swift_surface_env {
    void *swift_context;
    void *state;
    wl_swift_surface_destroy_func_t destroy;
    wl_swift_surface_attach_func_t attach;
    wl_swift_surface_damage_func_t damage;
    wl_swift_surface_frame_func_t frame;
    wl_swift_surface_set_opaque_region_func_t set_opaque_region;
    wl_swift_surface_set_input_region_func_t set_input_region;
    wl_swift_surface_commit_func_t commit;
    wl_swift_surface_set_buffer_transform_func_t set_buffer_transform;
    wl_swift_surface_set_buffer_scale_func_t set_buffer_scale;
    wl_swift_surface_damage_buffer_func_t damage_buffer;
    wl_swift_surface_offset_func_t offset;
};

static void _wl_swift_surface_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) env->destroy(env->swift_context, env->state, client, resource);
}

static void _wl_swift_surface_attach(struct wl_client *client, struct wl_resource *resource,
                                     struct wl_resource *buffer, int32_t x, int32_t y) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->attach) env->attach(env->swift_context, env->state, client, resource, buffer, x, y);
}

static void _wl_swift_surface_damage(struct wl_client *client, struct wl_resource *resource,
                                     int32_t x, int32_t y, int32_t width, int32_t height) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->damage) env->damage(env->swift_context, env->state, client, resource, x, y, width, height);
}

static void _wl_swift_surface_frame(struct wl_client *client, struct wl_resource *resource, uint32_t callback) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->frame) env->frame(env->swift_context, env->state, client, resource, callback);
}

static void _wl_swift_surface_set_opaque_region(struct wl_client *client, struct wl_resource *resource, struct wl_resource *region) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->set_opaque_region) env->set_opaque_region(env->swift_context, env->state, client, resource, region);
}

static void _wl_swift_surface_set_input_region(struct wl_client *client, struct wl_resource *resource, struct wl_resource *region) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->set_input_region) env->set_input_region(env->swift_context, env->state, client, resource, region);
}

static void _wl_swift_surface_commit(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->commit) env->commit(env->swift_context, env->state, client, resource);
}

static void _wl_swift_surface_set_buffer_transform(struct wl_client *client, struct wl_resource *resource, int32_t transform) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->set_buffer_transform) env->set_buffer_transform(env->swift_context, env->state, client, resource, transform);
}

static void _wl_swift_surface_set_buffer_scale(struct wl_client *client, struct wl_resource *resource, int32_t scale) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->set_buffer_scale) env->set_buffer_scale(env->swift_context, env->state, client, resource, scale);
}

static void _wl_swift_surface_damage_buffer(struct wl_client *client, struct wl_resource *resource,
                                            int32_t x, int32_t y, int32_t width, int32_t height) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->damage_buffer) env->damage_buffer(env->swift_context, env->state, client, resource, x, y, width, height);
}

static void _wl_swift_surface_offset(struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->offset) env->offset(env->swift_context, env->state, client, resource, x, y);
}

static void _wl_swift_surface_env_destroy(struct wl_resource *resource) {
    struct wl_swift_surface_env *env = (struct wl_swift_surface_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct wl_surface_interface wl_swift_surface_implementation = {
    .destroy = _wl_swift_surface_destroy,
    .attach = _wl_swift_surface_attach,
    .damage = _wl_swift_surface_damage,
    .frame = _wl_swift_surface_frame,
    .set_opaque_region = _wl_swift_surface_set_opaque_region,
    .set_input_region = _wl_swift_surface_set_input_region,
    .commit = _wl_swift_surface_commit,
    .set_buffer_transform = _wl_swift_surface_set_buffer_transform,
    .set_buffer_scale = _wl_swift_surface_set_buffer_scale,
    .damage_buffer = _wl_swift_surface_damage_buffer,
    .offset = _wl_swift_surface_offset,
};

static inline void wl_swift_set_surface_implementation(
    struct wl_resource *resource, struct wl_swift_surface_env *env)
{
    wl_resource_set_implementation(
        resource, &wl_swift_surface_implementation, env, _wl_swift_surface_env_destroy);
}

typedef void (*wl_swift_shm_create_pool_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    uint32_t id, int32_t fd, int32_t size);
typedef void (*wl_swift_shm_release_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);

struct wl_swift_shm_env {
    void *swift_context;
    void *state;
    wl_swift_shm_create_pool_func_t create_pool;
    wl_swift_shm_release_func_t release;
};

static void _wl_swift_shm_create_pool(struct wl_client *client, struct wl_resource *resource,
                                      uint32_t id, int32_t fd, int32_t size) {
    struct wl_swift_shm_env *env = (struct wl_swift_shm_env *)wl_resource_get_user_data(resource);
    if (env && env->create_pool) env->create_pool(env->swift_context, env->state, client, resource, id, fd, size);
}

static void _wl_swift_shm_release(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_shm_env *env = (struct wl_swift_shm_env *)wl_resource_get_user_data(resource);
    if (env && env->release) env->release(env->swift_context, env->state, client, resource);
}

static void _wl_swift_shm_env_destroy(struct wl_resource *resource) {
    struct wl_swift_shm_env *env = (struct wl_swift_shm_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct wl_shm_interface wl_swift_shm_implementation = {
    .create_pool = _wl_swift_shm_create_pool,
    .release = _wl_swift_shm_release,
};

static inline void wl_swift_set_shm_implementation(
    struct wl_resource *resource, struct wl_swift_shm_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_shm_implementation, env, _wl_swift_shm_env_destroy);
}



typedef void (*wl_swift_shm_pool_create_buffer_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource,
    uint32_t id, int32_t offset, int32_t width, int32_t height, int32_t stride, uint32_t format);
typedef void (*wl_swift_shm_pool_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_shm_pool_resize_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t size);

struct wl_swift_shm_pool_env {
    void *swift_context;
    void *state;
    wl_swift_shm_pool_create_buffer_func_t create_buffer;
    wl_swift_shm_pool_destroy_func_t destroy;
    wl_swift_shm_pool_resize_func_t resize;
};

static void _wl_swift_shm_pool_create_buffer(struct wl_client *client, struct wl_resource *resource,
                                             uint32_t id, int32_t offset, int32_t width, int32_t height,
                                             int32_t stride, uint32_t format) {
    struct wl_swift_shm_pool_env *env = (struct wl_swift_shm_pool_env *)wl_resource_get_user_data(resource);
    if (env && env->create_buffer) env->create_buffer(env->swift_context, env->state, client, resource, id, offset, width, height, stride, format);
}

static void _wl_swift_shm_pool_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_shm_pool_env *env = (struct wl_swift_shm_pool_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) env->destroy(env->swift_context, env->state, client, resource);
}

static void _wl_swift_shm_pool_resize(struct wl_client *client, struct wl_resource *resource, int32_t size) {
    struct wl_swift_shm_pool_env *env = (struct wl_swift_shm_pool_env *)wl_resource_get_user_data(resource);
    if (env && env->resize) env->resize(env->swift_context, env->state, client, resource, size);
}

static void _wl_swift_shm_pool_env_destroy(struct wl_resource *resource) {
    struct wl_swift_shm_pool_env *env = (struct wl_swift_shm_pool_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct wl_shm_pool_interface wl_swift_shm_pool_implementation = {
    .create_buffer = _wl_swift_shm_pool_create_buffer,
    .destroy = _wl_swift_shm_pool_destroy,
    .resize = _wl_swift_shm_pool_resize,
};

static inline void wl_swift_set_shm_pool_implementation(
    struct wl_resource *resource, struct wl_swift_shm_pool_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_shm_pool_implementation, env, _wl_swift_shm_pool_env_destroy);
}



static void _wl_swift_buffer_destroy(struct wl_client *client, struct wl_resource *resource) {
    (void)client; (void)resource;
}

static const struct wl_buffer_interface wl_swift_buffer_implementation = {
    .destroy = _wl_swift_buffer_destroy,
};

static inline void wl_swift_set_buffer_implementation(struct wl_resource *resource) {
    wl_resource_set_implementation(resource, &wl_swift_buffer_implementation, NULL, NULL);
}

typedef void (*wl_swift_seat_get_pointer_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_seat_get_keyboard_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_seat_get_touch_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_seat_release_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);

struct wl_swift_seat_env {
    void *swift_context;
    void *state;
    wl_swift_seat_get_pointer_func_t get_pointer;
    wl_swift_seat_get_keyboard_func_t get_keyboard;
    wl_swift_seat_get_touch_func_t get_touch;
    wl_swift_seat_release_func_t release;
};

static void _wl_swift_seat_get_pointer(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_seat_env *env = (struct wl_swift_seat_env *)wl_resource_get_user_data(resource);
    if (env && env->get_pointer) env->get_pointer(env->swift_context, env->state, client, resource, id);
}

static void _wl_swift_seat_get_keyboard(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_seat_env *env = (struct wl_swift_seat_env *)wl_resource_get_user_data(resource);
    if (env && env->get_keyboard) env->get_keyboard(env->swift_context, env->state, client, resource, id);
}

static void _wl_swift_seat_get_touch(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_seat_env *env = (struct wl_swift_seat_env *)wl_resource_get_user_data(resource);
    if (env && env->get_touch) env->get_touch(env->swift_context, env->state, client, resource, id);
}

static void _wl_swift_seat_release(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_seat_env *env = (struct wl_swift_seat_env *)wl_resource_get_user_data(resource);
    if (env && env->release) env->release(env->swift_context, env->state, client, resource);
}

static void _wl_swift_seat_env_destroy(struct wl_resource *resource) {
    struct wl_swift_seat_env *env = (struct wl_swift_seat_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct wl_seat_interface wl_swift_seat_implementation = {
    .get_pointer = _wl_swift_seat_get_pointer,
    .get_keyboard = _wl_swift_seat_get_keyboard,
    .get_touch = _wl_swift_seat_get_touch,
    .release = _wl_swift_seat_release,
};

static inline void wl_swift_set_seat_implementation(
    struct wl_resource *resource, struct wl_swift_seat_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_seat_implementation, env, _wl_swift_seat_env_destroy);
}

typedef void (*wl_swift_keyboard_release_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);

struct wl_swift_keyboard_env {
    void *swift_context;
    void *state;
    wl_swift_keyboard_release_func_t release;
};

static void _wl_swift_keyboard_release(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_keyboard_env *env = (struct wl_swift_keyboard_env *)wl_resource_get_user_data(resource);
    if (env && env->release) env->release(env->swift_context, env->state, client, resource);
}

static void _wl_swift_keyboard_env_destroy(struct wl_resource *resource) {
    struct wl_swift_keyboard_env *env = (struct wl_swift_keyboard_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct wl_keyboard_interface wl_swift_keyboard_implementation = {
    .release = _wl_swift_keyboard_release,
};

static inline void wl_swift_set_keyboard_implementation(
    struct wl_resource *resource, struct wl_swift_keyboard_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_keyboard_implementation, env, _wl_swift_keyboard_env_destroy);
}
