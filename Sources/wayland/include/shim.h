#pragma once

#include <wayland-client.h>
#include <wayland-client-core.h>
#include <wayland-client-protocol.h>

#include <wayland-server.h>
#include <wayland-server-core.h>
#include <wayland-server-protocol.h>
#include "xdg-shell-server-protocol.h"
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

#include "xdg-shell-server-protocol.h"
#include <xkbcommon/xkbcommon.h>
#include <stdlib.h>
#include <xkbcommon/xkbcommon-keysyms.h>



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

// ============================================================
// XDG Shell Compositor Support
// ============================================================

// ------------------------------------------------------------------
// xdg_wm_base
// ------------------------------------------------------------------

typedef void (*wl_swift_xdg_wm_base_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_wm_base_create_positioner_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_xdg_wm_base_get_xdg_surface_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id, struct wl_resource *surface);
typedef void (*wl_swift_xdg_wm_base_pong_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t serial);

struct wl_swift_xdg_wm_base_env {
    void *swift_context;
    void *state;
    void *destroy;
    void *create_positioner;
    void *get_xdg_surface;
    void *pong;
};

static void _wl_swift_xdg_wm_base_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_wm_base_env *env = (struct wl_swift_xdg_wm_base_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) ((wl_swift_xdg_wm_base_destroy_func_t)(env->destroy))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_wm_base_create_positioner(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_xdg_wm_base_env *env = (struct wl_swift_xdg_wm_base_env *)wl_resource_get_user_data(resource);
    if (env && env->create_positioner) ((wl_swift_xdg_wm_base_create_positioner_func_t)(env->create_positioner))(env->swift_context, env->state, client, resource, id);
}

static void _wl_swift_xdg_wm_base_get_xdg_surface(struct wl_client *client, struct wl_resource *resource, uint32_t id, struct wl_resource *surface) {
    struct wl_swift_xdg_wm_base_env *env = (struct wl_swift_xdg_wm_base_env *)wl_resource_get_user_data(resource);
    if (env && env->get_xdg_surface) ((wl_swift_xdg_wm_base_get_xdg_surface_func_t)(env->get_xdg_surface))(env->swift_context, env->state, client, resource, id, surface);
}

static void _wl_swift_xdg_wm_base_pong(struct wl_client *client, struct wl_resource *resource, uint32_t serial) {
    struct wl_swift_xdg_wm_base_env *env = (struct wl_swift_xdg_wm_base_env *)wl_resource_get_user_data(resource);
    if (env && env->pong) ((wl_swift_xdg_wm_base_pong_func_t)(env->pong))(env->swift_context, env->state, client, resource, serial);
}
static void _wl_swift_xdg_wm_base_env_destroy(struct wl_resource *resource) {
    struct wl_swift_xdg_wm_base_env *env = (struct wl_swift_xdg_wm_base_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct xdg_wm_base_interface wl_swift_xdg_wm_base_implementation = {
    .destroy = _wl_swift_xdg_wm_base_destroy,
    .create_positioner = _wl_swift_xdg_wm_base_create_positioner,
    .get_xdg_surface = _wl_swift_xdg_wm_base_get_xdg_surface,
    .pong = _wl_swift_xdg_wm_base_pong,
};

static inline void wl_swift_set_xdg_wm_base_implementation(
    struct wl_resource *resource, struct wl_swift_xdg_wm_base_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_xdg_wm_base_implementation, env, _wl_swift_xdg_wm_base_env_destroy);
}

static inline void wl_swift_xdg_wm_base_send_ping(
    struct wl_resource *resource, uint32_t serial)
{
    xdg_wm_base_send_ping(resource, serial);
}

// ------------------------------------------------------------------
// xdg_positioner
// ------------------------------------------------------------------

typedef void (*wl_swift_xdg_positioner_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_positioner_set_size_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height);
typedef void (*wl_swift_xdg_positioner_set_anchor_rect_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y, int32_t width, int32_t height);
typedef void (*wl_swift_xdg_positioner_set_anchor_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t anchor);
typedef void (*wl_swift_xdg_positioner_set_gravity_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t gravity);
typedef void (*wl_swift_xdg_positioner_set_constraint_adjustment_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t constraint_adjustment);
typedef void (*wl_swift_xdg_positioner_set_offset_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y);
typedef void (*wl_swift_xdg_positioner_set_reactive_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_positioner_set_parent_size_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t parent_width, int32_t parent_height);
typedef void (*wl_swift_xdg_positioner_set_parent_configure_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t serial);

struct wl_swift_xdg_positioner_env {
    void *swift_context;
    void *state;
    void *destroy;
    void *set_size;
    void *set_anchor_rect;
    void *set_anchor;
    void *set_gravity;
    void *set_constraint_adjustment;
    void *set_offset;
    void *set_reactive;
    void *set_parent_size;
    void *set_parent_configure;
};
static void _wl_swift_xdg_positioner_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) ((wl_swift_xdg_positioner_destroy_func_t)(env->destroy))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_positioner_set_size(struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_size) ((wl_swift_xdg_positioner_set_size_func_t)(env->set_size))(env->swift_context, env->state, client, resource, width, height);
}

static void _wl_swift_xdg_positioner_set_anchor_rect(struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y, int32_t width, int32_t height) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_anchor_rect) ((wl_swift_xdg_positioner_set_anchor_rect_func_t)(env->set_anchor_rect))(env->swift_context, env->state, client, resource, x, y, width, height);
}

static void _wl_swift_xdg_positioner_set_anchor(struct wl_client *client, struct wl_resource *resource, uint32_t anchor) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_anchor) ((wl_swift_xdg_positioner_set_anchor_func_t)(env->set_anchor))(env->swift_context, env->state, client, resource, anchor);
}

static void _wl_swift_xdg_positioner_set_gravity(struct wl_client *client, struct wl_resource *resource, uint32_t gravity) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_gravity) ((wl_swift_xdg_positioner_set_gravity_func_t)(env->set_gravity))(env->swift_context, env->state, client, resource, gravity);
}

static void _wl_swift_xdg_positioner_set_constraint_adjustment(struct wl_client *client, struct wl_resource *resource, uint32_t ca) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_constraint_adjustment) ((wl_swift_xdg_positioner_set_constraint_adjustment_func_t)(env->set_constraint_adjustment))(env->swift_context, env->state, client, resource, ca);
}
static void _wl_swift_xdg_positioner_set_offset(struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_offset) ((wl_swift_xdg_positioner_set_offset_func_t)(env->set_offset))(env->swift_context, env->state, client, resource, x, y);
}

static void _wl_swift_xdg_positioner_set_reactive(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_reactive) ((wl_swift_xdg_positioner_set_reactive_func_t)(env->set_reactive))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_positioner_set_parent_size(struct wl_client *client, struct wl_resource *resource, int32_t pw, int32_t ph) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_parent_size) ((wl_swift_xdg_positioner_set_parent_size_func_t)(env->set_parent_size))(env->swift_context, env->state, client, resource, pw, ph);
}

static void _wl_swift_xdg_positioner_set_parent_configure(struct wl_client *client, struct wl_resource *resource, uint32_t serial) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    if (env && env->set_parent_configure) ((wl_swift_xdg_positioner_set_parent_configure_func_t)(env->set_parent_configure))(env->swift_context, env->state, client, resource, serial);
}

static void _wl_swift_xdg_positioner_env_destroy(struct wl_resource *resource) {
    struct wl_swift_xdg_positioner_env *env = (struct wl_swift_xdg_positioner_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct xdg_positioner_interface wl_swift_xdg_positioner_implementation = {
    .destroy = _wl_swift_xdg_positioner_destroy,
    .set_size = _wl_swift_xdg_positioner_set_size,
    .set_anchor_rect = _wl_swift_xdg_positioner_set_anchor_rect,
    .set_anchor = _wl_swift_xdg_positioner_set_anchor,
    .set_gravity = _wl_swift_xdg_positioner_set_gravity,
    .set_constraint_adjustment = _wl_swift_xdg_positioner_set_constraint_adjustment,
    .set_offset = _wl_swift_xdg_positioner_set_offset,
    .set_reactive = _wl_swift_xdg_positioner_set_reactive,
    .set_parent_size = _wl_swift_xdg_positioner_set_parent_size,
    .set_parent_configure = _wl_swift_xdg_positioner_set_parent_configure,
};

static inline void wl_swift_set_xdg_positioner_implementation(
    struct wl_resource *resource, struct wl_swift_xdg_positioner_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_xdg_positioner_implementation, env, _wl_swift_xdg_positioner_env_destroy);
}
// ------------------------------------------------------------------
// xdg_surface
// ------------------------------------------------------------------

typedef void (*wl_swift_xdg_surface_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_surface_get_toplevel_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id);
typedef void (*wl_swift_xdg_surface_get_popup_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t id, struct wl_resource *parent, struct wl_resource *positioner);
typedef void (*wl_swift_xdg_surface_set_window_geometry_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y, int32_t width, int32_t height);
typedef void (*wl_swift_xdg_surface_ack_configure_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, uint32_t serial);

struct wl_swift_xdg_surface_env {
    void *swift_context;
    void *state;
    void *destroy;
    void *get_toplevel;
    void *get_popup;
    void *set_window_geometry;
    void *ack_configure;
};

static void _wl_swift_xdg_surface_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) ((wl_swift_xdg_surface_destroy_func_t)(env->destroy))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_surface_get_toplevel(struct wl_client *client, struct wl_resource *resource, uint32_t id) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->get_toplevel) ((wl_swift_xdg_surface_get_toplevel_func_t)(env->get_toplevel))(env->swift_context, env->state, client, resource, id);
}
static void _wl_swift_xdg_surface_get_popup(struct wl_client *client, struct wl_resource *resource, uint32_t id, struct wl_resource *parent, struct wl_resource *positioner) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->get_popup) ((wl_swift_xdg_surface_get_popup_func_t)(env->get_popup))(env->swift_context, env->state, client, resource, id, parent, positioner);
}

static void _wl_swift_xdg_surface_set_window_geometry(struct wl_client *client, struct wl_resource *resource, int32_t x, int32_t y, int32_t width, int32_t height) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->set_window_geometry) ((wl_swift_xdg_surface_set_window_geometry_func_t)(env->set_window_geometry))(env->swift_context, env->state, client, resource, x, y, width, height);
}

static void _wl_swift_xdg_surface_ack_configure(struct wl_client *client, struct wl_resource *resource, uint32_t serial) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    if (env && env->ack_configure) ((wl_swift_xdg_surface_ack_configure_func_t)(env->ack_configure))(env->swift_context, env->state, client, resource, serial);
}

static void _wl_swift_xdg_surface_env_destroy(struct wl_resource *resource) {
    struct wl_swift_xdg_surface_env *env = (struct wl_swift_xdg_surface_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct xdg_surface_interface wl_swift_xdg_surface_implementation = {
    .destroy = _wl_swift_xdg_surface_destroy,
    .get_toplevel = _wl_swift_xdg_surface_get_toplevel,
    .get_popup = _wl_swift_xdg_surface_get_popup,
    .set_window_geometry = _wl_swift_xdg_surface_set_window_geometry,
    .ack_configure = _wl_swift_xdg_surface_ack_configure,
};

static inline void wl_swift_set_xdg_surface_implementation(
    struct wl_resource *resource, struct wl_swift_xdg_surface_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_xdg_surface_implementation, env, _wl_swift_xdg_surface_env_destroy);
}

static inline void wl_swift_xdg_surface_send_configure(
    struct wl_resource *resource, uint32_t serial)
{
    xdg_surface_send_configure(resource, serial);
}
// ------------------------------------------------------------------
// xdg_toplevel
// ------------------------------------------------------------------

typedef void (*wl_swift_xdg_toplevel_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_toplevel_set_parent_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *parent);
typedef void (*wl_swift_xdg_toplevel_set_title_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, const char *title);
typedef void (*wl_swift_xdg_toplevel_set_app_id_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, const char *app_id);
typedef void (*wl_swift_xdg_toplevel_show_window_menu_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial, int32_t x, int32_t y);
typedef void (*wl_swift_xdg_toplevel_move_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial);
typedef void (*wl_swift_xdg_toplevel_resize_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial, uint32_t edges);
typedef void (*wl_swift_xdg_toplevel_set_max_size_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height);
typedef void (*wl_swift_xdg_toplevel_set_min_size_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height);
typedef void (*wl_swift_xdg_toplevel_set_maximized_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_toplevel_unset_maximized_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_toplevel_set_fullscreen_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *output);
typedef void (*wl_swift_xdg_toplevel_unset_fullscreen_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_toplevel_set_minimized_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);

struct wl_swift_xdg_toplevel_env {
    void *swift_context;
    void *state;
    void *destroy;
    void *set_parent;
    void *set_title;
    void *set_app_id;
    void *show_window_menu;
    void *move;
    void *resize;
    void *set_max_size;
    void *set_min_size;
    void *set_maximized;
    void *unset_maximized;
    void *set_fullscreen;
    void *unset_fullscreen;
    void *set_minimized;
};
static void _wl_swift_xdg_toplevel_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) ((wl_swift_xdg_toplevel_destroy_func_t)(env->destroy))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_toplevel_set_parent(struct wl_client *client, struct wl_resource *resource, struct wl_resource *parent) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_parent) ((wl_swift_xdg_toplevel_set_parent_func_t)(env->set_parent))(env->swift_context, env->state, client, resource, parent);
}

static void _wl_swift_xdg_toplevel_set_title(struct wl_client *client, struct wl_resource *resource, const char *title) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_title) ((wl_swift_xdg_toplevel_set_title_func_t)(env->set_title))(env->swift_context, env->state, client, resource, title);
}

static void _wl_swift_xdg_toplevel_set_app_id(struct wl_client *client, struct wl_resource *resource, const char *app_id) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_app_id) ((wl_swift_xdg_toplevel_set_app_id_func_t)(env->set_app_id))(env->swift_context, env->state, client, resource, app_id);
}

static void _wl_swift_xdg_toplevel_show_window_menu(struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial, int32_t x, int32_t y) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->show_window_menu) ((wl_swift_xdg_toplevel_show_window_menu_func_t)(env->show_window_menu))(env->swift_context, env->state, client, resource, seat, serial, x, y);
}

static void _wl_swift_xdg_toplevel_move(struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->move) ((wl_swift_xdg_toplevel_move_func_t)(env->move))(env->swift_context, env->state, client, resource, seat, serial);
}

static void _wl_swift_xdg_toplevel_resize(struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial, uint32_t edges) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->resize) ((wl_swift_xdg_toplevel_resize_func_t)(env->resize))(env->swift_context, env->state, client, resource, seat, serial, edges);
}
static void _wl_swift_xdg_toplevel_set_max_size(struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_max_size) ((wl_swift_xdg_toplevel_set_max_size_func_t)(env->set_max_size))(env->swift_context, env->state, client, resource, width, height);
}

static void _wl_swift_xdg_toplevel_set_min_size(struct wl_client *client, struct wl_resource *resource, int32_t width, int32_t height) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_min_size) ((wl_swift_xdg_toplevel_set_min_size_func_t)(env->set_min_size))(env->swift_context, env->state, client, resource, width, height);
}

static void _wl_swift_xdg_toplevel_set_maximized(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_maximized) ((wl_swift_xdg_toplevel_set_maximized_func_t)(env->set_maximized))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_toplevel_unset_maximized(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->unset_maximized) ((wl_swift_xdg_toplevel_unset_maximized_func_t)(env->unset_maximized))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_toplevel_set_fullscreen(struct wl_client *client, struct wl_resource *resource, struct wl_resource *output) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_fullscreen) ((wl_swift_xdg_toplevel_set_fullscreen_func_t)(env->set_fullscreen))(env->swift_context, env->state, client, resource, output);
}

static void _wl_swift_xdg_toplevel_unset_fullscreen(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->unset_fullscreen) ((wl_swift_xdg_toplevel_unset_fullscreen_func_t)(env->unset_fullscreen))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_toplevel_set_minimized(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    if (env && env->set_minimized) ((wl_swift_xdg_toplevel_set_minimized_func_t)(env->set_minimized))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_toplevel_env_destroy(struct wl_resource *resource) {
    struct wl_swift_xdg_toplevel_env *env = (struct wl_swift_xdg_toplevel_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct xdg_toplevel_interface wl_swift_xdg_toplevel_implementation = {
    .destroy = _wl_swift_xdg_toplevel_destroy,
    .set_parent = _wl_swift_xdg_toplevel_set_parent,
    .set_title = _wl_swift_xdg_toplevel_set_title,
    .set_app_id = _wl_swift_xdg_toplevel_set_app_id,
    .show_window_menu = _wl_swift_xdg_toplevel_show_window_menu,
    .move = _wl_swift_xdg_toplevel_move,
    .resize = _wl_swift_xdg_toplevel_resize,
    .set_max_size = _wl_swift_xdg_toplevel_set_max_size,
    .set_min_size = _wl_swift_xdg_toplevel_set_min_size,
    .set_maximized = _wl_swift_xdg_toplevel_set_maximized,
    .unset_maximized = _wl_swift_xdg_toplevel_unset_maximized,
    .set_fullscreen = _wl_swift_xdg_toplevel_set_fullscreen,
    .unset_fullscreen = _wl_swift_xdg_toplevel_unset_fullscreen,
    .set_minimized = _wl_swift_xdg_toplevel_set_minimized,
};
static inline void wl_swift_set_xdg_toplevel_implementation(
    struct wl_resource *resource, struct wl_swift_xdg_toplevel_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_xdg_toplevel_implementation, env, _wl_swift_xdg_toplevel_env_destroy);
}

static inline void wl_swift_xdg_toplevel_send_configure(
    struct wl_resource *resource, int32_t width, int32_t height, struct wl_array *states)
{
    xdg_toplevel_send_configure(resource, width, height, states);
}

static inline void wl_swift_xdg_toplevel_send_close(
    struct wl_resource *resource)
{
    xdg_toplevel_send_close(resource);
}

static inline void wl_swift_xdg_toplevel_send_configure_bounds(
    struct wl_resource *resource, int32_t width, int32_t height)
{
    xdg_toplevel_send_configure_bounds(resource, width, height);
}

static inline void wl_swift_xdg_toplevel_send_wm_capabilities(
    struct wl_resource *resource, struct wl_array *capabilities)
{
    xdg_toplevel_send_wm_capabilities(resource, capabilities);
}
// ------------------------------------------------------------------
// xdg_popup
// ------------------------------------------------------------------

typedef void (*wl_swift_xdg_popup_destroy_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource);
typedef void (*wl_swift_xdg_popup_grab_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial);
typedef void (*wl_swift_xdg_popup_reposition_func_t)(
    void *ctx, void *state, struct wl_client *client, struct wl_resource *resource, struct wl_resource *positioner, uint32_t token);

struct wl_swift_xdg_popup_env {
    void *swift_context;
    void *state;
    void *destroy;
    void *grab;
    void *reposition;
};

static void _wl_swift_xdg_popup_destroy(struct wl_client *client, struct wl_resource *resource) {
    struct wl_swift_xdg_popup_env *env = (struct wl_swift_xdg_popup_env *)wl_resource_get_user_data(resource);
    if (env && env->destroy) ((wl_swift_xdg_popup_destroy_func_t)(env->destroy))(env->swift_context, env->state, client, resource);
}

static void _wl_swift_xdg_popup_grab(struct wl_client *client, struct wl_resource *resource, struct wl_resource *seat, uint32_t serial) {
    struct wl_swift_xdg_popup_env *env = (struct wl_swift_xdg_popup_env *)wl_resource_get_user_data(resource);
    if (env && env->grab) ((wl_swift_xdg_popup_grab_func_t)(env->grab))(env->swift_context, env->state, client, resource, seat, serial);
}

static void _wl_swift_xdg_popup_reposition(struct wl_client *client, struct wl_resource *resource, struct wl_resource *positioner, uint32_t token) {
    struct wl_swift_xdg_popup_env *env = (struct wl_swift_xdg_popup_env *)wl_resource_get_user_data(resource);
    if (env && env->reposition) ((wl_swift_xdg_popup_reposition_func_t)(env->reposition))(env->swift_context, env->state, client, resource, positioner, token);
}

static void _wl_swift_xdg_popup_env_destroy(struct wl_resource *resource) {
    struct wl_swift_xdg_popup_env *env = (struct wl_swift_xdg_popup_env *)wl_resource_get_user_data(resource);
    free(env);
}

static const struct xdg_popup_interface wl_swift_xdg_popup_implementation = {
    .destroy = _wl_swift_xdg_popup_destroy,
    .grab = _wl_swift_xdg_popup_grab,
    .reposition = _wl_swift_xdg_popup_reposition,
};
static inline void wl_swift_set_xdg_popup_implementation(
    struct wl_resource *resource, struct wl_swift_xdg_popup_env *env)
{
    wl_resource_set_implementation(resource, &wl_swift_xdg_popup_implementation, env, _wl_swift_xdg_popup_env_destroy);
}

static inline void wl_swift_xdg_popup_send_configure(
    struct wl_resource *resource, int32_t x, int32_t y, int32_t width, int32_t height)
{
    xdg_popup_send_configure(resource, x, y, width, height);
}

static inline void wl_swift_xdg_popup_send_popup_done(
    struct wl_resource *resource)
{
    xdg_popup_send_popup_done(resource);
}

static inline void wl_swift_xdg_popup_send_repositioned(
    struct wl_resource *resource, uint32_t token)
{
    xdg_popup_send_repositioned(resource, token);
}

// ------------------------------------------------------------------
// Interface helper functions
// ------------------------------------------------------------------

static inline const struct wl_interface *wl_swift_xdg_wm_base_interface(void) { return &xdg_wm_base_interface; }
static inline const struct wl_interface *wl_swift_xdg_positioner_interface(void) { return &xdg_positioner_interface; }
static inline const struct wl_interface *wl_swift_xdg_surface_interface(void) { return &xdg_surface_interface; }
static inline const struct wl_interface *wl_swift_xdg_toplevel_interface(void) { return &xdg_toplevel_interface; }
static inline const struct wl_interface *wl_swift_xdg_popup_interface(void) { return &xdg_popup_interface; }