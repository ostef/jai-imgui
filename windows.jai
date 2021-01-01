#assert OS == .WINDOWS "This file should only be loaded on Windows";

// Context creation and access
// Each context create its own ImFontAtlas by default. You may instance one yourself and pass it to CreateContext() to share a font atlas between imgui contexts.
// None of those functions is reliant on the current context.
ImGui_CreateContext :: (shared_font_atlas : *ImFontAtlas = null) -> *ImGuiContext #foreign imgui "?CreateContext@ImGui@@YAPEAUImGuiContext@@PEAUImFontAtlas@@@Z";
ImGui_DestroyContext :: (ctx : *ImGuiContext = null) #foreign imgui "?DestroyContext@ImGui@@YAXPEAUImGuiContext@@@Z";
ImGui_GetCurrentContext :: () -> *ImGuiContext #foreign imgui "?GetCurrentContext@ImGui@@YAPEAUImGuiContext@@XZ";
ImGui_SetCurrentContext :: (ctx : *ImGuiContext) #foreign imgui "?SetCurrentContext@ImGui@@YAXPEAUImGuiContext@@@Z";

// Main
// access the IO structure (mouse/keyboard/gamepad inputs, time, various configuration options/flags)
ImGui_GetIO :: () -> *ImGuiIO #foreign imgui "?GetIO@ImGui@@YAAEAUImGuiIO@@XZ";
// access the Style structure (colors, sizes). Always use PushStyleCol(), PushStyleVar() to modify style mid-frame!
ImGui_GetStyle :: () -> *ImGuiStyle #foreign imgui "?GetStyle@ImGui@@YAAEAUImGuiStyle@@XZ";
// start a new Dear ImGui frame, you can submit any command from this point until Render()/EndFrame().
ImGui_NewFrame :: () #foreign imgui "?NewFrame@ImGui@@YAXXZ";
// ends the Dear ImGui frame. automatically called by Render(). If you don't need to render data (skipping rendering) you may call EndFrame() without Render()... but you'll have wasted CPU already! If you don't need to render, better to not create any windows and not call NewFrame() at all!
ImGui_EndFrame :: () #foreign imgui "?EndFrame@ImGui@@YAXXZ";
// ends the Dear ImGui frame, finalize the draw data. You can get call GetDrawData() to obtain it and run your rendering function (up to v1.60, this used to call io.RenderDrawListsFn(). Nowadays, we allow and prefer calling your render function yourself.)
ImGui_Render :: () #foreign imgui "?Render@ImGui@@YAXXZ";
// valid after Render() and until the next call to NewFrame(). this is what you have to render.
ImGui_GetDrawData :: () -> *ImDrawData #foreign imgui "?GetDrawData@ImGui@@YAPEAUImDrawData@@XZ";

// Demo, Debug, Information
// create Demo window (previously called ShowTestWindow). demonstrate most ImGui features. call this to learn about the library! try to make it always available in your application!
ImGui_ShowDemoWindow :: (open : *bool = null) #foreign imgui "?ShowDemoWindow@ImGui@@YAXPEA_N@Z";
// create About window. display Dear ImGui version, credits and build/system information.
ImGui_ShowAboutWindow :: (open : *bool = null) #foreign imgui "?ShowAboutWindow@ImGui@@YAXPEA_N@Z";
// create Debug/Metrics window. display Dear ImGui internals: draw commands (with individual draw calls and vertices), window list, basic internal state, etc.
ImGui_ShowMetricsWindow :: (open : *bool = null) #foreign imgui "?ShowMetricsWindow@ImGui@@YAXPEA_N@Z";
// add style editor block (not a window). you can pass in a reference ImGuiStyle structure to compare to, revert to and save to (else it uses the default style)
ImGui_ShowStyleEditor :: (ref : *ImGuiStyle = null) #foreign imgui "?ShowStyleEditor@ImGui@@YAXPEAUImGuiStyle@@@Z";
// add style selector block (not a window), essentially a combo listing the default styles.
ImGui_ShowStyleSelector :: (label : *u8) -> bool #foreign imgui "?ShowStyleSelector@ImGui@@YA_NPEBD@Z";
// add font selector block (not a window), essentially a combo listing the loaded fonts.
ImGui_ShowFontSelector :: (label : *u8) #foreign imgui "?ShowFontSelector@ImGui@@YAXPEBD@Z";
// add basic help/info block (not a window): how to manipulate ImGui as a end-user (mouse/keyboard controls).
ImGui_ShowUseGuide :: () #foreign imgui "?ShowUserGuide@ImGui@@YAXXZ";
// get the compiled version string e.g. "1.23" (essentially the compiled value for IMGUI_VERSION)
ImGui_GetVersion :: () -> *u8 #foreign imgui "?GetVersion@ImGui@@YAPEBDXZ";

// Styles
// new, recommended style (default)
ImGui_StyleColorsDark :: (dst : *ImGuiStyle = null) #foreign imgui "?StyleColorsDark@ImGui@@YAXPEAUImGuiStyle@@@Z";
// classic imgui style
ImGui_StyleColorsClassic :: (dst : *ImGuiStyle = null) #foreign imgui "?StyleColorsClassic@ImGui@@YAXPEAUImGuiStyle@@@Z";
// best used with borders and a custom, thicker font
ImGui_StyleColorsLight :: (dst : *ImGuiStyle = null) #foreign imgui "?StyleColorsLight@ImGui@@YAXPEAUImGuiStyle@@@Z";

// Windows
// - Begin() = push window to the stack and start appending to it. End() = pop window from the stack.
// - Passing 'bool* p_open != NULL' shows a window-closing widget in the upper-right corner of the window,
//   which clicking will set the boolean to false when clicked.
// - You may append multiple times to the same window during the same frame by calling Begin()/End() pairs multiple times.
//   Some information such as 'flags' or 'p_open' will only be considered by the first call to Begin().
// - Begin() return false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
//   anything to the window. Always call a matching End() for each Begin() call, regardless of its return value!
//   [Important: due to legacy reason, this is inconsistent with most other functions such as BeginMenu/EndMenu,
//    BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding BeginXXX function
//    returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
// - Note that the bottom of window stack always contains a window called "Debug".
ImGui_Begin :: (name : *u8, open : *bool = null, flags : ImGuiWindowFlags = 0) -> bool #foreign imgui "?Begin@ImGui@@YA_NPEBDPEA_NH@Z";
ImGui_End :: () #foreign imgui "?End@ImGui@@YAXXZ";

// Child Windows
// - Use child windows to begin into a self-contained independent scrolling/clipping regions within a host window. Child windows can embed their own child.
// - For each independent axis of 'size': ==0.0f: use remaining host window size / >0.0f: fixed size / <0.0f: use remaining window size minus abs(size) / Each axis can use a different mode, e.g. ImVec2(0,400).
// - BeginChild() returns false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting anything to the window.
//   Always call a matching EndChild() for each BeginChild() call, regardless of its return value [as with Begin: this is due to legacy reason and inconsistent with most BeginXXX functions apart from the regular Begin() which behaves like BeginChild().]
ImGui_BeginChild :: inline (id : *u8, size : ImVec2 = .{ 0, 0 }, border := false, flags : ImGuiWindowFlags = 0) -> bool { return ImGui__BeginChild (id, *size, border, flags); }
ImGui_BeginChild :: inline (id : ImGuiID, size : ImVec2 = .{ 0, 0 }, border := false, flags : ImGuiWindowFlags = 0) -> bool { return ImGui__BeginChild (id, *size, border, flags); }
ImGui_EndChild :: () #foreign imgui "?EndChild@ImGui@@YAXXZ";

ImGui__BeginChild :: (id : *u8, const_ref_size : *ImVec2, border : bool, flags : ImGuiWindowFlags) -> bool #foreign imgui "?BeginChild@ImGui@@YA_NPEBDAEBUImVec2@@_NH@Z";
ImGui__BeginChild :: (id : ImGuiID, const_ref_size : *ImVec2, border : bool, flags : ImGuiWindowFlags) -> bool #foreign imgui "?BeginChild@ImGui@@YA_NIAEBUImVec2@@_NH@Z";

// Windows Utilities
// - 'current window' = the window we are appending into while inside a Begin()/End() block. 'next window' = next window we will Begin() into.
ImGui_IsWindowAppearing :: () -> bool #foreign imgui "?IsWindowAppearing@ImGui@@YA_NXZ";
ImGui_IsWindowCollapsed :: () -> bool #foreign imgui "?IsWindowCollapsed@ImGui@@YA_NXZ";
// is current window focused? or its root/child, depending on flags. see flags for options.
ImGui_IsWindowFocused :: (flags : ImGuiFocusedFlags = 0) -> bool #foreign imgui "?IsWindowFocused@ImGui@@YA_NH@Z";
// is current window hovered (and typically: not blocked by a popup/modal)? see flags for options. NB: If you are trying to check whether your mouse should be dispatched to imgui or to your app, you should use the 'io.WantCaptureMouse' boolean for that! Please read the FAQ!
ImGui_IsWindowHovered :: (flags : ImGuiFocusedFlags = 0) -> bool #foreign imgui "?IsWindowHovered@ImGui@@YA_NH@Z";
// get draw list associated to the current window, to append your own drawing primitives
ImGui_GetWindowDrawList :: () -> *ImDrawList #foreign imgui "?GetWindowDrawList@ImGui@@YAPEAUImDrawList@@XZ";
// get current window position in screen space (useful if you want to do your own drawing via the DrawList API)
ImGui_GetWindowPos :: () -> ImVec2 #foreign imgui "?GetWindowPos@ImGui@@YA?AUImVec2@@XZ";
// get current window size
ImGui_GetWindowSize :: () -> ImVec2 #foreign imgui "?GetWindowSize@ImGui@@YA?AUImVec2@@XZ";
// get current window width (shortcut for GetWindowSize().x)
ImGui_GetWindowWidth :: () -> float #foreign imgui "?GetWindowWidth@ImGui@@YAMXZ";
// get current window height (shortcut for GetWindowSize().y)
ImGui_GetWindowHeight :: () -> float #foreign imgui "?GetWindowHeight@ImGui@@YAMXZ";

// Prefer using SetNextXXX functions (before Begin) rather that SetXXX functions (after Begin).
// set next window position. call before Begin(). use pivot=(0.5f,0.5f) to center on given point, etc.
ImGui_SetNextWindowPos :: inline (pos : ImVec2, cond : ImGuiCond = 0, pivot : ImVec2 = .{ 0, 0 }) { ImGui__SetNextWindowPos (*pos, cond, *pivot); }
// set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
ImGui_SetNextWindowSize :: inline (size : ImVec2, cond : ImGuiCond = 0) { ImGui__SetNextWindowSize (*size, cond); }
// set next window size limits. use -1,-1 on either X/Y axis to preserve the current size. Sizes will be rounded down. Use callback to apply non-trivial programmatic constraints.
ImGui_SetNextWindowSizeConstraints :: inline (size_min : ImVec2, size_max : ImVec2, custom_callback : ImGuiSizeCallback = null, custom_callback_data : *void = null) { ImGui__SetNextWindowSizeConstraints (*size_min, *size_max, custom_callback, custom_callback_data); }
// set next window content size (~ scrollable client area, which enforce the range of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor WindowPadding. set an axis to 0.0f to leave it automatic. call before Begin()
ImGui_SetNextWindowContentSize :: inline (size : ImVec2) { ImGui__SetNextWindowContentSize (*size); }
// set next window collapsed state. call before Begin()
ImGui_SetNextWindowCollapsed :: (collapsed : bool, cond : ImGuiCond = 0) #foreign imgui "?SetNextWindowCollapsed@ImGui@@YAX_NH@Z";
// set next window to be focused / top-most. call before Begin()
ImGui_SetNextWindowFocus :: () #foreign imgui "?SetNextWindowFocus@ImGui@@YAXXZ";
// set next window background color alpha. helper to easily override the Alpha component of ImGuiCol_WindowBg/ChildBg/PopupBg. you may also use ImGuiWindowFlags_NoBackground.
ImGui_SetNextWindowBgAlpha :: (alpha : float) #foreign imgui "?SetNextWindowBgAlpha@ImGui@@YAXM@Z";
// (not recommended) set current window position - call within Begin()/End(). prefer using SetNextWindowPos(), as this may incur tearing and side-effects.
ImGui_SetWindowPos :: inline (pos : ImVec2, cond : ImGuiCond = 0) { ImGui__SetWindowPos (*pos, cond); }
// (not recommended) set current window size - call within Begin()/End(). set to ImVec2(0, 0) to force an auto-fit. prefer using SetNextWindowSize(), as this may incur tearing and minor side-effects.
ImGui_SetWindowSize :: inline (size : ImVec2, cond : ImGuiCond = 0) { ImGui__SetWindowSize (*size, cond); }
// (not recommended) set current window collapsed state. prefer using SetNextWindowCollapsed().
ImGui_SetWindowCollapsed :: (collapsed : bool, cond : ImGuiCond = 0) #foreign imgui "?SetWindowCollapsed@ImGui@@YAX_NH@Z";
// (not recommended) set current window to be focused / top-most. prefer using SetNextWindowFocus().
ImGui_SetWindowFocus :: () #foreign imgui "?SetWindowFocus@ImGui@@YAXXZ";
// set font scale. Adjust IO.FontGlobalScale if you want to scale all windows. This is an old API! For correct scaling, prefer to reload font + rebuild ImFontAtlas + call style.ScaleAllSizes().
ImGui_SetWindowFontScale :: () #foreign imgui "?SetWindowFontScale@ImGui@@YAXM@Z";
// set named window position.
ImGui_SetWindowPos :: inline (name : *u8, pos : ImVec2, cond : ImGuiCond = 0) { ImGui__SetWindowPos (name, *pos, cond); }
// set named window size. set axis to 0.0f to force an auto-fit on this axis.
ImGui_SetWindowSize :: inline (name : *u8, size : ImVec2, cond : ImGuiCond = 0) { ImGui__SetWindowSize (name, *size, cond); }
// set named window collapsed state
ImGui_SetWindowCollapsed :: (name : *u8, collapsed : bool, cond : ImGuiCond = 0) #foreign imgui "?SetWindowCollapsed@ImGui@@YAX_NH@Z";
// set named window to be focused / top-most. use NULL to remove focus.
ImGui_SetWindowFocus :: (name : *u8) #foreign imgui "?SetWindowFocus@ImGui@@YAXPEBD@Z";

ImGui__SetNextWindowPos :: (const_ref_pos : *ImVec2, cond : ImGuiCond, const_ref_pivot : *ImVec2) #foreign imgui "?SetNextWindowPos@ImGui@@YAXAEBUImVec2@@H0@Z";
ImGui__SetNextWindowSize :: (const_ref_size : *ImVec2, cond : ImGuiCond) #foreign imgui "?SetNextWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
ImGui__SetNextWindowSizeConstraints :: (const_ref_size_min : *ImVec2, const_ref_size_max : *ImVec2, custom_callback : ImGuiSizeCallback, custom_callback_data : *void) #foreign imgui "?SetNextWindowSizeConstraints@ImGui@@YAXAEBUImVec2@@0P6AXPEAUImGuiSizeCallbackData@@@ZPEAX@Z";
ImGui__SetNextWindowContentSize :: (const_ref_size : *ImVec2) #foreign imgui "?SetNextWindowContentSize@ImGui@@YAXAEBUImVec2@@@Z";
ImGui__SetWindowPos :: (const_ref_pos : *ImVec2, cond : ImGuiCond) #foreign imgui "?SetWindowPos@ImGui@@YAXAEBUImVec2@@H@Z";
ImGui__SetWindowSize :: (const_ref_size : *ImVec2, cond : ImGuiCond) #foreign imgui "?SetWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
ImGui__SetWindowPos :: (name : *u8, const_ref_pos : *ImVec2, cond : ImGuiCond) #foreign imgui "?SetWindowPos@ImGui@@YAXPEBDAEBUImVec2@@H@Z";
ImGui__SetWindowSize :: (name : *u8, const_ref_size : *ImVec2, cond : ImGuiCond) #foreign imgui "?SetWindowSize@ImGui@@YAXPEBDAEBUImVec2@@H@Z";

// Content region
// - Those functions are bound to be redesigned soon (they are confusing, incomplete and return values in local window coordinates which increases confusion)
// current content boundaries (typically window boundaries including scrolling, or current column boundaries), in windows coordinates
ImGui_GetContentRegionMax :: () -> ImVec2 #foreign imgui "?GetContentRegionMax@ImGui@@YA?AUImVec2@@XZ";
// == GetContentRegionMax() - GetCursorPos()
ImGui_GetContentRegionAvail :: () -> ImVec2 #foreign imgui "?GetContentRegionAvail@ImGui@@YA?AUImVec2@@XZ";
// content boundaries min (roughly (0,0)-Scroll), in window coordinates
ImGui_GetWindowContentRegionMin :: () -> ImVec2 #foreign imgui "?GetWindowContentRegionMin@ImGui@@YA?AUImVec2@@XZ";
// content boundaries max (roughly (0,0)+Size-Scroll) where Size can be override with SetNextWindowContentSize(), in window coordinates
ImGui_GetWindowContentRegionMax :: () -> ImVec2 #foreign imgui "?GetWindowContentRegionMax@ImGui@@YA?AUImVec2@@XZ";
ImGui_GetWindowContentRegionWidth :: () -> ImVec2 #foreign imgui "?GetWindowContentRegionWidth@ImGui@@YAMXZ";

// Windows Scrolling
// get scrolling amount [0..GetScrollMaxX()]
ImGui_GetScrollX :: () -> float #foreign imgui "?GetScrollX@ImGui@@YAMXZ";
// get scrolling amount [0..GetScrollMaxY()]
ImGui_GetScrollY :: () -> float #foreign imgui "?GetScrollY@ImGui@@YAMXZ";
// get maximum scrolling amount ~~ ContentSize.x - WindowSize.x
ImGui_GetScrollMaxX :: () -> float #foreign imgui "?GetScrollMaxX@ImGui@@YAMXZ";
// get maximum scrolling amount ~~ ContentSize.y - WindowSize.y
ImGui_GetScrollMaxY :: () -> float #foreign imgui "?GetScrollMaxY@ImGui@@YAMXZ";
// set scrolling amount [0..GetScrollMaxX()]
ImGui_SetScrollX :: (scroll_x : float) #foreign imgui "?SetScrollX@ImGui@@YAXM@Z";
// set scrolling amount [0..GetScrollMaxY()]
ImGui_SetScrollY :: (scroll_y : float) #foreign imgui "?SetScrollY@ImGui@@YAXM@Z";
// adjust scrolling amount to make current cursor position visible. center_x_ratio=0.0: left, 0.5: center, 1.0: right. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
ImGui_SetScrollHereX :: (center_x_ratio : float = 0.5) #foreign imgui "?SetScrollHereX@ImGui@@YAXM@Z";
// adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
ImGui_SetScrollHereY :: (center_y_ratio : float = 0.5) #foreign imgui "?SetScrollHereY@ImGui@@YAXM@Z";
// adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.
ImGui_SetScrollFromPosX :: (local_x : float, center_x_ratio : float = 0.5) #foreign imgui "?SetScrollFromPosX@ImGui@@YAXMM@Z";
// adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.
ImGui_SetScrollFromPosY :: (local_y : float, center_y_ratio : float = 0.5) #foreign imgui "?SetScrollFromPosY@ImGui@@YAXMM@Z";

// Parameters stacks (shared)
// use NULL as a shortcut to push default font
ImGui_PushFont :: (font : *ImFont) #foreign imgui "?PushFont@ImGui@@YAXPEAUImFont@@@Z";
ImGui_PopFont :: () #foreign imgui "?PopFont@ImGui@@YAXXZ";
ImGui_PushStyleColor :: (idx : ImGuiCol, col : u32) #foreign imgui "?PushStyleColor@ImGui@@YAXHI@Z";
ImGui_PushStyleColor :: inline (idx : ImGuiCol, col : ImVec4) { ImGui__PushStyleColor (idx, *col); }
ImGui_PopStyleColor :: (count : s32 = 1) #foreign imgui "?PopStyleColor@ImGui@@YAXH@Z";
ImGui_PushStyleVar :: (idx : ImGuiStyleVar, val : float) #foreign imgui "?PushStyleVar@ImGui@@YAXHM@Z";
ImGui_PushStyleVar :: inline (idx : ImGuiStyleVar, val : ImVec2) { ImGui__PushStyleVar (idx, *val); }
ImGui_PopStyleVar :: (count : s32 = 1) #foreign imgui "?PopStyleVar@ImGui@@YAXH@Z";
// retrieve style color as stored in ImGuiStyle structure. use to feed back into PushStyleColor(), otherwise use GetColorU32() to get style color with style alpha baked in.
ImGui_GetStyleColorVec4 :: inline (idx : ImGuiCol) -> ImVec4 { return <<ImGui__GetStyleColorVec4 (idx); }
// get current font
ImGui_GetFont :: () -> *ImFont #foreign imgui "?GetFont@ImGui@@YAPEAUImFont@@XZ";
// get current font size (= height in pixels) of current font with current scale applied
ImGui_GetFontSize :: () -> float #foreign imgui "?GetFontSize@ImGui@@YAMXZ";
// get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API
ImGui_GetFontTexUvWhitePixel :: () -> ImVec2 #foreign imgui "?GetFontTexUvWhitePixel@ImGui@@YA?AUImVec2@@XZ";
// retrieve given style color with style alpha applied and optional extra alpha multiplier
ImGui_GetColorU32 :: (idx : ImGuiCol, alpha_mul : float = 1) -> u32 #foreign imgui "?GetColorU32@ImGui@@YAIHM@Z";
// retrieve given color with style alpha applied
ImGui_GetColorU32 :: inline (col : ImVec4) -> u32 { return ImGui__GetColorU32 (*col); }
// retrieve given color with style alpha applied
ImGui_GetColorU32 :: (col : u32) -> u32 #foreign imgui "?GetColorU32@ImGui@@YAII@Z";

ImGui__PushStyleColor :: (idx : ImGuiCol, const_ref_col : *ImVec4) #foreign imgui "?PushStyleColor@ImGui@@YAXHAEBUImVec4@@@Z";
ImGui__PushStyleVar :: (idx : ImGuiStyleVar, const_ref_val : *ImVec2) #foreign imgui "?PushStyleVar@ImGui@@YAXHAEBUImVec2@@@Z";
ImGui__GetStyleColorVec4 :: (idx : ImGuiCol) -> *ImVec4 #foreign imgui "?GetStyleColorVec4@ImGui@@YAAEBUImVec4@@H@Z";
ImGui__GetColorU32 :: (const_ref_col : *ImVec4) -> u32 #foreign imgui "?GetColorU32@ImGui@@YAIAEBUImVec4@@@Z";

// Parameters stacks (current window)
// push width of items for common large "item+label" widgets. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side). 0.0f = default to ~2/3 of windows width,
ImGui_PushItemWidth :: (item_width : float) #foreign imgui "?PushItemWidth@ImGui@@YAXM@Z";
// set width of the _next_ common large "item+label" widget. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side)
ImGui_PopItemWidth :: () #foreign imgui "?PopItemWidth@ImGui@@YAXXZ";
// width of item given pushed settings and current cursor position. NOT necessarily the width of last item unlike most 'Item' functions.
ImGui_CalcItemWidth :: () -> float #foreign imgui "?CalcItemWidth@ImGui@@YAMXZ";
// set width of the _next_ common large "item+label" widget. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side)
ImGui_SetNextItemWidth :: (item_width : float) #foreign imgui "?SetNextItemWidth@ImGui@@YAXM@Z";
// push word-wrapping position for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position in window local space
ImGui_PushTextWrapPos :: (wrap_local_pos_x : float = 0) #foreign imgui "?PushTextWrapPos@ImGui@@YAXM@Z";
ImGui_PopTextWrapPos :: () #foreign imgui "?PopTextWrapPos@ImGui@@YAXXZ";
// allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
ImGui_PushAllowKeyboardFocus :: (allow_keyboard_focus : bool) #foreign imgui "?PushAllowKeyboardFocus@ImGui@@YAX_N@Z";
ImGui_PopAllowKeyboardFocus :: () #foreign imgui "?PopAllowKeyboardFocus@ImGui@@YAXXZ";
// in 'repeat' mode, Button*() functions return repeated true in a typematic manner (using io.KeyRepeatDelay/io.KeyRepeatRate setting). Note that you can call IsItemActive() after any Button() to tell if the button is held in the current frame.
ImGui_PushButtonRepeat :: (repeat : bool) #foreign imgui "?PushButtonRepeat@ImGui@@YAX_N@Z";
ImGui_PopButtonRepeat :: () #foreign imgui "?PopButtonRepeat@ImGui@@YAXXZ";

// Cursor / Layout
// - By "cursor" we mean the current output position.
// - The typical widget behavior is to output themselves at the current cursor position, then move the cursor one line down.
// - You can call SameLine() between widgets to undo the last carriage return and output at the right of the preceding widget.
// - Attention! We currently have inconsistencies between window-local and absolute positions we will aim to fix with future API:
//    Window-local coordinates:   SameLine(), GetCursorPos(), SetCursorPos(), GetCursorStartPos(), GetContentRegionMax(), GetWindowContentRegion*(), PushTextWrapPos()
//    Absolute coordinate:        GetCursorScreenPos(), SetCursorScreenPos(), all ImDrawList:: functions.
// separator, generally horizontal. inside a menu bar or in horizontal layout mode, this becomes a vertical separator.
ImGui_Separator :: () #foreign imgui "?Separator@ImGui@@YAXXZ";
// call between widgets or groups to layout them horizontally. X position given in window coordinates.
ImGui_SameLine :: (offset_from_start_x : float = 0, spacing : float = -1) #foreign imgui "?SameLine@ImGui@@YAXMM@Z";
// undo a SameLine() or force a new line when in an horizontal-layout context.
ImGui_NewLine :: () #foreign imgui "?NewLine@ImGui@@YAXXZ";
// add vertical spacing.
ImGui_Spacing :: () #foreign imgui "?Spacing@ImGui@@YAXXZ";
// add a dummy item of given size. unlike InvisibleButton(), Dummy() won't take the mouse click or be navigable into.
ImGui_Dummy :: inline (size : ImVec2) { ImGui__Dummy (*size); }
// move content position toward the right, by style.IndentSpacing or indent_w if != 0
ImGui_Indent :: (indent_w : float = 0) #foreign imgui "?Indent@ImGui@@YAXM@Z";
// move content position back to the left, by style.IndentSpacing or indent_w if != 0
ImGui_Unindent :: (indent_w : float = 0) #foreign imgui "?Unindent@ImGui@@YAXM@Z";
// lock horizontal starting position
ImGui_BeginGroup :: () #foreign imgui "?BeginGroup@ImGui@@YAXXZ";
// unlock horizontal starting position + capture the whole group bounding box into one "item" (so you can use IsItemHovered() or layout primitives such as SameLine() on whole group, etc.)
ImGui_EndGroup :: () #foreign imgui "?EndGroup@ImGui@@YAXXZ";
// cursor position in window coordinates (relative to window position)
ImGui_GetCursorPos :: () -> ImVec2 #foreign imgui "?GetCursorPos@ImGui@@YA?AUImVec2@@XZ";
ImGui_GetCursorPosX :: () -> float #foreign imgui "?GetCursorPosX@ImGui@@YAMXZ";
ImGui_GetCursorPosY :: () -> float #foreign imgui "?GetCursorPosY@ImGui@@YAMXZ";
ImGui_SetCursorPos :: inline (local_pos : ImVec2) { ImGui__SetCursorPos (*local_pos); }
ImGui_SetCursorPosX :: (local_x : float) #foreign imgui "?SetCursorPosX@ImGui@@YAXM@Z";
ImGui_SetCursorPosY :: (local_y : float) #foreign imgui "?SetCursorPosY@ImGui@@YAXM@Z";
// initial cursor position in window coordinates
ImGui_GetCursorStartPos :: () -> ImVec2 #foreign imgui "?GetCursorStartPos@ImGui@@YA?AUImVec2@@XZ";
// cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)
ImGui_GetCursorScreenPos :: () -> ImVec2 #foreign imgui "?GetCursorScreenPos@ImGui@@YA?AUImVec2@@XZ";
// cursor position in absolute screen coordinates [0..io.DisplaySize]
ImGui_SetCursorScreenPos :: inline (pos : ImVec2) { ImGui__SetCursorScreenPos (*pos); } 
// vertically align upcoming text baseline to FramePadding.y so that it will align properly to regularly framed items (call if you have text on a line before a framed item)
ImGui_AlignTextToFramePadding :: () #foreign imgui "?AlignTextToFramePadding@ImGui@@YAXXZ";
// ~ FontSize
ImGui_GetTextLineHeight :: () -> float #foreign imgui "?GetTextLineHeight@ImGui@@YAMXZ";
// ~ FontSize + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of text)
Imgui_GetTextLineHeightWithSpacing :: () -> float #foreign imgui "?GetTextLineHeightWithSpacing@ImGui@@YAMXZ";
// ~ FontSize + style.FramePadding.y * 2
ImGui_GetFrameHeight :: () -> float #foreign imgui "?GetFrameHeight@ImGui@@YAMXZ";
// ~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)
ImGui_GetFrameHeightWithSpacing :: () -> float #foreign imgui "?GetFrameHeightWithSpacing@ImGui@@YAMXZ";

ImGui__Dummy :: (const_ref_size : *ImVec2) #foreign imgui "?Dummy@ImGui@@YAXAEBUImVec2@@@Z";
ImGui__SetCursorPos :: (const_ref_local_pos : *ImVec2) #foreign imgui "?SetCursorPos@ImGui@@YAXAEBUImVec2@@@Z";
ImGui__SetCursorScreenPos :: (const_ref_pos : *ImVec2) #foreign imgui "?SetCursorScreenPos@ImGui@@YAXAEBUImVec2@@@Z";

// ID stack/scopes
// - Read the FAQ for more details about how ID are handled in dear imgui. If you are creating widgets in a loop you most
//   likely want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
// - The resulting ID are hashes of the entire stack.
// - You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
// - In this header file we use the "label"/"name" terminology to denote a string that will be displayed and used as an ID,
//   whereas "str_id" denote a string that is only used as an ID and not normally displayed.
// push string into the ID stack (will hash string).
ImGui_PushID :: (str_id : *u8) #foreign imgui "?PushID@ImGui@@YAXPEBD@Z";
// push string into the ID stack (will hash string).
ImGui_PushID :: (str_id_begin : *u8, str_id_end : *u8) #foreign imgui "?PushID@ImGui@@YAXPEBD0@Z";
ImGui_PushID :: inline (str : string) { ImGui_PushID (str.data, str.data + str.count); } 
// push pointer into the ID stack (will hash pointer).
ImGui_PushID :: (ptr_id : *void) #foreign imgui "?PushID@ImGui@@YAXPEBX@Z";
// push integer into the ID stack (will hash integer).
ImGui_PushID :: (int_id : s32) #foreign imgui "?PushID@ImGui@@YAXH@Z";
// pop from the ID stack.
ImGui_PopID :: () #foreign imgui "?PopID@ImGui@@YAXXZ";
// calculate unique ID (hash of whole ID stack + given parameter). e.g. if you want to query into ImGuiStorage yourself
ImGui_GetID :: (str_id : *u8) -> ImGuiID #foreign imgui "?GetID@ImGui@@YAIPEBD@Z";
ImGui_GetID :: (str_id_begin : *u8, str_id_end : *u8) -> ImGuiID #foreign imgui "?GetID@ImGui@@YAIPEBD0@Z";
ImGui_GetID :: inline (str : string) -> ImGuiID { return ImGui_GetID (str.data, str.data + str.count); }
ImGui_GetID :: (ptr_id : *void) -> ImGuiID #foreign imgui "?GetID@ImGui@@YAIPEBX@Z";

// Widgets: Text
// raw text without formatting. Roughly equivalent to Text("%s", text) but: A) doesn't require null terminated string if 'text_end' is specified, B) it's faster, no memory copy is done, no buffer size limits, recommended for long chunks of text.
ImGui_TextUnformatted :: (text : *u8, text_end : *u8 = null) #foreign imgui "?TextUnformatted@ImGui@@YAXPEBD0@Z";
ImGui_Text :: inline (fmt : string, args : ..Any) { formatted := tprint (fmt, ..args); ImGui_TextUnformatted (formatted.data, formatted.data + formatted.count); }
ImGui_TextColored :: inline (col : ImVec4, fmt : string, args : ..Any) { ImGui_PushStyleColor (.Text, col); defer ImGui_PopStyleColor (); ImGui_Text (fmt, ..args); }
ImGui_TextDisabled :: inline (fmt : string, args : ..Any) { ImGui_TextColored (ImGui_GetStyle ().Colors[ImGuiCol.TextDisabled], fmt, ..args); }
ImGui_TextWrapped :: inline (fmt : string, args : ..Any) { ImGui_PushTextWrapPos (0); defer ImGui_PopTextWrapPos (); ImGui_Text (fmt, ..args); }
ImGui_LabelText :: inline (label : *u8, fmt : string, args : ..Any) { formatted := tprint (fmt, ..args); ImGui__LabelText (label, temp_c_string (formatted)); }
ImGui_BulletText :: inline (fmt : string, args : ..Any) { formatted := tprint (fmt, ..args); ImGui__BulletText (temp_c_string (formatted)); }

ImGui__LabelText :: (label : *u8, fmt : *u8, args : ..Any) #foreign imgui "?LabelText@ImGui@@YAXPEBD0ZZ";
ImGui__BulletText :: (fmt : *u8, args : ..Any) #foreign imgui "?BulletText@ImGui@@YAXPEBDZZ";

// Widgets: Main
// - Most widgets return true when the value has been changed or when pressed/selected
// - You may also use one of the many IsItemXXX functions (e.g. IsItemActive, IsItemHovered, etc.) to query widget state.
ImGui_Button :: inline (label : *u8, size : ImVec2 = .{ 0, 0 }) -> bool { return ImGui__Button (label, *size); }
// button with FramePadding=(0,0) to easily embed within text
ImGui_SmallButton :: (label : *u8) -> bool #foreign imgui "?SmallButton@ImGui@@YA_NPEBD@Z";
// flexible button behavior without the visuals, frequently useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)
ImGui_InvisibleButton :: inline (str_id : *u8, size : ImVec2, flags : ImGuiButtonFlags = 0) -> bool { return ImGui__InvisibleButton (str_id, *size, flags); }
// square button with an arrow shape
ImGui_ArrowButton :: (str_id : *u8, dir : ImGuiDir) -> bool #foreign imgui "?ArrowButton@ImGui@@YA_NPEBDH@Z";
ImGui_Image :: inline (user_texture_id : ImTextureID, size : ImVec2, uv0 : ImVec2 = .{ 0, 0 }, uv1 : ImVec2 = .{ 0, 0 }, frame_padding : s32 = -1, tint_col : ImVec4 = .{ 1, 1, 1, 1 }, border_col : ImVec4 = .{ 0, 0, 0, 0 }) { ImGui__Image (user_texture_id, *size, *uv0, *uv1, frame_padding, *tint_col, *border_col); }
// <0 frame_padding uses default frame padding settings. 0 for no padding
ImGui_ImageButton :: inline (user_texture_id : ImTextureID, size : ImVec2, uv0 : ImVec2 = .{ 0, 0 }, uv1 : ImVec2 = .{ 0, 0 }, frame_padding : s32 = -1, bg_col : ImVec4 = .{ 0, 0, 0, 0 }, tint_col : ImVec4 = .{ 1, 1, 1, 1 }) -> bool { return ImGui__ImageButton (user_texture_id, *size, *uv0, *uv1, frame_padding, *bg_col, *tint_col); }
ImGui_Checkbox :: (label : *u8, v : *bool) -> bool #foreign imgui "?Checkbox@ImGui@@YA_NPEBDPEA_N@Z";
ImGui_CheckboxFlags :: (label : *u8, flags : *u32, flags_value : u32) -> bool #foreign imgui "?CheckboxFlags@ImGui@@YA_NPEBDPEAII@Z";
// use with e.g. if (RadioButton("one", my_value==1)) { my_value = 1; }
ImGui_RadioButton :: (label : *u8, active : bool) -> bool #foreign imgui "?RadioButton@ImGui@@YA_NPEBD_N@Z";
// shortcut to handle the above pattern when value is an integer
ImGui_RadioButton :: (label : *u8, v : *s32, v_button : s32) -> bool #foreign imgui "?RadioButton@ImGui@@YA_NPEBDPEAHH@Z";
ImGui_ProgressBar :: inline (fraction : float, size_arg : ImVec2 = .{ -1, 0 }, overlay : *u8 = null) { ImGui__ProgressBar (fraction, *size_arg, overlay); }
// draw a small circle + keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses
ImGui_Bullet :: () #foreign imgui "?Bullet@ImGui@@YAXXZ";

ImGui__Button :: (label : *u8, const_ref_size : *ImVec2) -> bool #foreign imgui "?Button@ImGui@@YA_NPEBDAEBUImVec2@@@Z";
ImGui__InvisibleButton :: (str_id : *u8, const_ref_size : *ImVec2, flags : ImGuiButtonFlags) -> bool #foreign imgui "?InvisibleButton@ImGui@@YA_NPEBDAEBUImVec2@@H@Z";
ImGui__Image :: (user_texture_id : ImTextureID, const_ref_size : *ImVec2, const_ref_uv0 : *ImVec2, const_ref_uv1 : *ImVec2, frame_padding : s32, const_ref_tint_col : *ImVec4, const_ref_border_col : *ImVec4) #foreign imgui "?Image@ImGui@@YAXPEAXAEBUImVec2@@11AEBUImVec4@@2@Z";
ImGui__ImageButton :: (user_texture_id : ImTextureID, const_ref_size : *ImVec2, const_ref_uv0 : *ImVec2, const_ref_uv1 : *ImVec2, frame_padding : s32, const_ref_bg_col : *ImVec4, const_ref_tint_col : *ImVec4) -> bool #foreign imgui "?ImageButton@ImGui@@YA_NPEAXAEBUImVec2@@11HAEBUImVec4@@2@Z";
ImGui__ProgressBar :: (fraction : float, const_ref_size_arg : *ImVec2, overlay : *u8) #foreign imgui "?ProgressBar@ImGui@@YAXMAEBUImVec2@@PEBD@Z";

// Widgets: Combo Box
// - The BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() items.
// - The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose.
ImGui_BeginCombo :: (label : *u8, preview_value : *u8, flags : ImGuiComboFlags = 0) -> bool #foreign imgui "?BeginCombo@ImGui@@YA_NPEBD0H@Z";
// only call EndCombo() if BeginCombo() returns true!
ImGui_EndCombo :: () #foreign imgui "?EndCombo@ImGui@@YAXXZ";
ImGui_Combo :: inline (label : *u8, current_item : *s32, items : []*u8, popup_max_height_in_items : s32 = -1) -> bool { return ImGui__Combo (label, current_item, items.data, xx items.count, popup_max_height_in_items); }
// Separate items with \0 within a string, end item-list with \0\0. e.g. "One\0Two\0Three\0"
ImGui_Combo :: (label : *u8, current_item : *s32, items_separated_by_zeros : *u8, popup_max_height_in_items : s32 = -1) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAH0H@Z";
ImGui_Combo :: (label : *u8, current_item : *s32, items_getter : (data : *void, idx : s32, out_text : **u8) -> bool #c_call, data : *void, items_count : s32, popup_max_height_in_items : s32 = -1) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";

ImGui__Combo :: (label : *u8, current_item : *s32, items : **u8, items_count : s32, popup_max_height_in_items : s32) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";

// Widgets: Drag Sliders
// - CTRL+Click on any drag box to turn them into an input box. Manually input values aren't clamped and can go off-bounds.
// - For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, note that a 'float v[X]' function argument is the same as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Speed are per-pixel of mouse movement (v_speed=0.2f: mouse needs to move by 5 pixels to increase value by 1). For gamepad/keyboard navigation, minimum speed is Max(v_speed, minimum_step_at_given_precision).
// - Use v_min < v_max to clamp edits to given limits. Note that CTRL+Click manual input can override those limits.
// - Use v_max = FLT_MAX / INT_MAX etc to avoid clamping to a maximum, same with v_min = -FLT_MAX / INT_MIN to avoid clamping to a minimum.
// - We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
// - Legacy: Pre-1.78 there are DragXXX() function signatures that takes a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
// If v_min >= v_max we have no bound
ImGui_DragFloat :: (label : *u8, v : *float, v_speed : float = 1, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragFloat@ImGui@@YA_NPEBDPEAMMMM0H@Z";
ImGui_DragFloat2 :: (label : *u8, v : *float, v_speed : float = 1, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragFloat2@ImGui@@YA_NPEBDQEAMMMM0H@Z";
ImGui_DragFloat3 :: (label : *u8, v : *float, v_speed : float = 1, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragFloat3@ImGui@@YA_NPEBDQEAMMMM0H@Z";
ImGui_DragFloat4 :: (label : *u8, v : *float, v_speed : float = 1, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragFloat4@ImGui@@YA_NPEBDQEAMMMM0H@Z";
ImGui_DragFloatRange2 :: (label : *u8, v_current_min : *float, v_current_max : *float, v_speed : float = 1, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", format_max : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragFloatRange2@ImGui@@YA_NPEBDPEAM1MMM00H@Z";
// If v_min >= v_max we have no bound
ImGui_DragInt :: (label : *u8, v : *s32, v_speed : float = 1, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragInt@ImGui@@YA_NPEBDPEAHMHH0H@Z";
ImGui_DragInt2 :: (label : *u8, v : *s32, v_speed : float = 1, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragInt2@ImGui@@YA_NPEBDQEAHMHH0H@Z";
ImGui_DragInt3 :: (label : *u8, v : *s32, v_speed : float = 1, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragInt3@ImGui@@YA_NPEBDQEAHMHH0H@Z";
ImGui_DragInt4 :: (label : *u8, v : *s32, v_speed : float = 1, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragInt4@ImGui@@YA_NPEBDQEAHMHH0H@Z";
ImGui_DragIntRange2 :: (label : *u8, v_current_min : *s32, v_current_max : *s32, v_speed : float = 1, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", format_max : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragIntRange2@ImGui@@YA_NPEBDPEAH1MHH00H@Z";
ImGui_DragScalar :: (label : *u8, data_type : ImGuiDataType, data : *void, v_speed : float, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragScalar@ImGui@@YA_NPEBDHPEAXMPEBX20H@Z";
ImGui_DragScalarN :: (label : *u8, data_type : ImGuiDataType, data : *void, components : s32, v_speed : float, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?DragScalarN@ImGui@@YA_NPEBDHPEAXHMPEBX20H@Z";

// Widgets: Regular Sliders
// - CTRL+Click on any slider to turn them into an input box. Manually input values aren't clamped and can go off-bounds.
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Legacy: Pre-1.78 there are SliderXXX() function signatures that takes a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
// adjust format to decorate the value with a prefix or a suffix for in-slider labels or unit display.
ImGui_SliderFloat :: (label : *u8, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
ImGui_SliderFloat2 :: (label : *u8, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderFloat2@ImGui@@YA_NPEBDQEAMMM0H@Z";
ImGui_SliderFloat3 :: (label : *u8, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderFloat3@ImGui@@YA_NPEBDQEAMMM0H@Z";
ImGui_SliderFloat4 :: (label : *u8, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderFloat4@ImGui@@YA_NPEBDQEAMMM0H@Z";
ImGui_SliderAngle :: (label : *u8, v_rad : *float, v_degrees_min : float = -360, v_degrees_max : float = +360, format : *u8 = "%.0f deg", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderAngle@ImGui@@YA_NPEBDPEAMMM0H@Z";
ImGui_SliderInt :: (label : *u8, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderInt@ImGui@@YA_NPEBDPEAHHH0H@Z";
ImGui_SliderInt2 :: (label : *u8, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderInt2@ImGui@@YA_NPEBDQEAHHH0H@Z";
ImGui_SliderInt3 :: (label : *u8, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderInt3@ImGui@@YA_NPEBDQEAHHH0H@Z";
ImGui_SliderInt4 :: (label : *u8, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderInt4@ImGui@@YA_NPEBDQEAHHH0H@Z";
ImGui_SliderScalar :: (label : *u8, data_type : ImGuiDataType, data : *void, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
ImGui_SliderScalarN :: (label : *u8, data_type : ImGuiDataType, data : *void, components : s32, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?SliderScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";
ImGui_VSliderFloat :: inline (label : *u8, size : ImVec2, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool { return ImGui__VSliderFloat (label, *size, v, v_min, v_max, format, flags); }
ImGui_VSliderInt :: inline (label : *u8, size : ImVec2, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool { return ImGui__VSliderInt (label, *size, v, v_min, v_max, format, flags); }
ImGui_VSliderScalar :: inline (label : *u8, size : ImVec2, data_type : ImGuiDataType, data : *void, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool { return ImGui__VSliderScalar (label, *size, data_type, data, min, max, format, flags); }

ImGui__VSliderFloat :: (label : *u8, const_ref_size : *ImVec2, v : *float, v_min : float = 0, v_max : float = 0, format : *u8 = "%.3f", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?VSliderFloat@ImGui@@YA_NPEBDAEBUImVec2@@PEAMMM0H@Z";
ImGui__VSliderInt :: (label : *u8, const_ref_size : *ImVec2, v : *s32, v_min : s32 = 0, v_max : s32 = 0, format : *u8 = "%d", flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?VSliderInt@ImGui@@YA_NPEBDAEBUImVec2@@PEAHHH0H@Z";
ImGui__VSliderScalar :: (label : *u8, const_ref_size : *ImVec2, data_type : ImGuiDataType, data : *void, min : *void = null, max : *void = null, format : *u8 = null, flags : ImGuiSliderFlags = 0) -> bool #foreign imgui "?VSliderScalar@ImGui@@YA_NPEBDAEBUImVec2@@HPEAXPEBX30H@Z";

// Widgets: Input with Keyboard
// - If you want to use InputText() with std::string or any custom dynamic string type, see misc/cpp/imgui_stdlib.h and comments in imgui_demo.cpp.
// - Most of the ImGuiInputTextFlags flags are only useful for InputText() and not for InputFloatX, InputIntX, InputDouble etc.
ImGui_InputText :: (label : *u8, buf : *u8, buf_size : u64, flags : ImGuiInputTextFlags = 0, callback : ImGuiInputTextCallback = null, user_data : *void = null) -> bool #foreign imgui "?InputText@ImGui@@YA_NPEBDPEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
ImGui_InputTextMultiline :: inline (label : *u8, buf : *u8, buf_size : u64, size : ImVec2 = .{ 0, 0 }, flags : ImGuiInputTextFlags = 0, callback : ImGuiInputTextCallback = null, user_data : *void = null) -> bool { return ImGui__InputTextMultiline (label, buf, buf_size, *size, flags, callback, user_data); }
ImGui_InputTextWithHint :: (label : *u8, hint : *u8, buf : *u8, buf_size : u64, flags : ImGuiInputTextFlags = 0, callback : ImGuiInputTextCallback = null, user_data : *void = null) -> bool #foreign imgui "?InputTextWithHint@ImGui@@YA_NPEBD0PEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
ImGui_InputFloat :: (label : *u8, v : *float, step : float = 0, step_fast : float = 0, format : *u8 = "%.3f", flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
ImGui_InputFloat2 :: (label : *u8, v : *float, format : *u8 = "%.3f", flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputFloat2@ImGui@@YA_NPEBDQEAM0H@Z";
ImGui_InputFloat3 :: (label : *u8, v : *float, format : *u8 = "%.3f", flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputFloat3@ImGui@@YA_NPEBDQEAM0H@Z";
ImGui_InputFloat4 :: (label : *u8, v : *float, format : *u8 = "%.3f", flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputFloat4@ImGui@@YA_NPEBDQEAM0H@Z";
ImGui_InputInt :: (label : *u8, v : *s32, step : s32 = 1, step_fast : s32 = 100, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputInt@ImGui@@YA_NPEBDPEAHHHH@Z";
ImGui_InputInt2 :: (label : *u8, v : *s32, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputInt2@ImGui@@YA_NPEBDQEAHH@Z";
ImGui_InputInt3 :: (label : *u8, v : *s32, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputInt3@ImGui@@YA_NPEBDQEAHH@Z";
ImGui_InputInt4 :: (label : *u8, v : *s32, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputInt4@ImGui@@YA_NPEBDQEAHH@Z";
ImGui_InputDouble :: (label : *u8, v : *float64, step : float64 = 0, step_fast : float64 = 0, format : *u8 = "%.6f", flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputDouble@ImGui@@YA_NPEBDPEANNN0H@Z";
ImGui_InputScalar :: (label : *u8, data_type : ImGuiDataType, data : *void, step : *void = null, step_fast : *void = null, format : *u8 = null, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
ImGui_InputScalarN :: (label : *u8, data_type : ImGuiDataType, data : *void, components : s32, step : *void = null, step_fast : *void = null, format : *u8 = null, flags : ImGuiInputTextFlags = 0) -> bool #foreign imgui "?InputScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";

ImGui__InputTextMultiline :: (label : *u8, buf : *u8, buf_size : u64, const_ref_size : *ImVec2, flags : ImGuiInputTextFlags, callback : ImGuiInputTextCallback, user_data : *void) -> bool #foreign imgui "?InputTextMultiline@ImGui@@YA_NPEBDPEAD_KAEBUImVec2@@HP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";

// Widgets: Color Editor/Picker (tip: the ColorEdit* functions have a little colored preview square that can be left-clicked to open a picker, and right-clicked to open an option menu.)
// - Note that in C++ a 'float v[X]' function argument is the _same_ as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible.
// - You can pass the address of a first float element out of a contiguous structure, e.g. &myvector.x
ImGui_ColorEdit3 :: (label : *u8, col : *float, flags : ImGuiColorEditFlags = 0) -> bool #foreign imgui "?ColorEdit3@ImGui@@YA_NPEBDQEAMH@Z";
ImGui_ColorEdit4 :: (label : *u8, col : *float, flags : ImGuiColorEditFlags = 0) -> bool #foreign imgui "?ColorEdit4@ImGui@@YA_NPEBDQEAMH@Z";
ImGui_ColorPicker3 :: (label : *u8, col : *float, flags : ImGuiColorEditFlags = 0) -> bool #foreign imgui "?ColorPicker3@ImGui@@YA_NPEBDQEAMH@Z";
ImGui_ColorPicker4 :: (label : *u8, col : *float, flags : ImGuiColorEditFlags = 0, ref_col : *float = null) -> bool #foreign imgui "?ColorPicker4@ImGui@@YA_NPEBDQEAMHPEBM@Z";
// display a colored square/button, hover for details, return true when pressed.
ImGui_ColorButton :: inline (desc_id : *u8, col : ImVec4, flags : ImGuiColorEditFlags = 0, size : ImVec2 = .{ 0, 0 }) -> bool { return ImGui__ColorButton (desc_id, *col, flags, size); }
// initialize current options (generally on application startup) if you want to select a default format, picker type, etc. User will be able to change many settings, unless you pass the _NoOptions flag to your calls.
ImGui_SetColorEditOptions :: (flags : ImGuiColorEditFlags) #foreign imgui "?SetColorEditOptions@ImGui@@YAXH@Z";

ImGui__ColorButton :: (desc_id : *u8, const_ref_col : *ImVec4, flags : ImGuiColorEditFlags, size : ImVec2) -> bool #foreign imgui "?ColorButton@ImGui@@YA_NPEBDAEBUImVec4@@HUImVec2@@@Z";

// Widgets: Trees
// - TreeNode functions return true when the node is open, in which case you need to also call TreePop() when you are finished displaying the tree node contents.
ImGui_TreeNode :: (label : *u8) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBD@Z";
ImGui_TreeNode :: inline (str_id : *u8, fmt : string, args : ..Any) -> bool { formatted := tprint (fmt, ..args); return ImGui__TreeNode (str_id, temp_c_string (formatted)); }
ImGui_TreeNode :: inline (ptr_id : *void, fmt : string, args : ..Any) -> bool { formatted := tprint (fmt, ..args); return ImGui__TreeNode (ptr_id, temp_c_string (formatted)); }
ImGui_TreeNodeEx :: (label : *u8, flags : ImGuiTreeNodeFlags) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBDH@Z";
ImGui_TreeNodeEx :: (str_id : *u8, flags : ImGuiTreeNodeFlags, fmt : string, args : ..Any) -> bool { formatted := tprint (fmt, ..args); return ImGui__TreeNodeEx (str_id, flags, temp_c_string (formatted)); }
ImGui_TreeNodeEx :: (ptr_id : *void, flags : ImGuiTreeNodeFlags, fmt : string, args : ..Any) -> bool { formatted := tprint (fmt, ..args); return ImGui__TreeNodeEx (ptr_id, flags, temp_c_string (formatted)); }
// ~ Indent()+PushId(). Already called by TreeNode() when returning true, but you can call TreePush/TreePop yourself if desired.
ImGui_TreePush :: (str_id : *u8) #foreign imgui "?TreePush@ImGui@@YAXPEBD@Z";
ImGui_TreePush :: (ptr_id : *void = null) #foreign imgui "?TreePush@ImGui@@YAXPEBX@Z";
// ~ Unindent()+PopId()
ImGui_TreePop :: () #foreign imgui "?TreePop@ImGui@@YAXXZ";
// horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
ImGui_GetTreeNodeToLabelSpacing :: () -> float #foreign imgui "?GetTreeNodeToLabelSpacing@ImGui@@YAMXZ";
// if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
ImGui_CollapsingHeader :: (label : *u8, flags : ImGuiTreeNodeFlags = 0) -> bool #foreign imgui "?CollapsingHeader@ImGui@@YA_NPEBDH@Z";
// when 'p_open' isn't NULL, display an additional small close button on upper right of the header
ImGui_CollapsingHeader :: (label : *u8, open : *bool, flags : ImGuiTreeNodeFlags = 0) -> bool #foreign imgui "?CollapsingHeader@ImGui@@YA_NPEBDPEA_NH@Z";
// set next TreeNode/CollapsingHeader open state.
ImGui_SetNextItemOpen :: (is_open : bool, cond : ImGuiCond = 0) #foreign imgui "?SetNextItemOpen@ImGui@@YAX_NH@Z";

ImGui__TreeNode :: (str_id : *u8, c_style_fmt : *u8, args : ..Any) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBD0ZZ";
ImGui__TreeNode :: (ptr_id : *void, c_style_fmt : *u8, args : ..Any) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBXPEBDZZ";
ImGui__TreeNodeEx :: (str_id : *u8, flags : ImGuiTreeNodeFlags, label : *u8) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBDH0ZZ";
ImGui__TreeNodeEx :: (ptr_id : *void, flags : ImGuiTreeNodeFlags, label : *u8) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBXHPEBDZZ";

// Widgets: Selectables
// - A selectable highlights when hovered, and can display another color when selected.
// - Neighbors selectable extend their highlight bounds in order to leave no gap between them. This is so a series of selected Selectable appear contiguous.
// "bool selected" carry the selection state (read-only). Selectable() is clicked is returns true so you can modify your selection state. size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
ImGui_Selectable :: inline (label : *u8, selected : bool = false, flags : ImGuiSelectableFlags = 0, size : ImVec2 = .{ 0, 0 }) -> bool { return ImGui__Selectable (label, selected, flags, *size); }
// "bool* p_selected" point to the selection state (read-write), as a convenient helper.
ImGui_Selectable :: inline (label : *u8, selected : *bool, flags : ImGuiSelectableFlags = 0, size : ImVec2 = .{ 0, 0 }) -> bool { return ImGui__Selectable (label, selected, flags, *size); }

ImGui__Selectable :: (label : *u8, selected : bool, flags : ImGuiSelectableFlags, const_ref_size : *ImVec2) -> bool #foreign imgui "?Selectable@ImGui@@YA_NPEBD_NHAEBUImVec2@@@Z";
ImGui__Selectable :: (label : *u8, selected : *bool, flags : ImGuiSelectableFlags, const_ref_size : *ImVec2) -> bool #foreign imgui "?Selectable@ImGui@@YA_NPEBDPEA_NHAEBUImVec2@@@Z";

// Widgets: List Boxes
// - FIXME: To be consistent with all the newer API, ListBoxHeader/ListBoxFooter should in reality be called BeginListBox/EndListBox. Will rename them.
ImGui_ListBox :: inline (label : *u8, current_item : *s32, items : []*u8, height_in_items : s32 = -1) -> bool { return ImGui__ListBox (label, current_item, items.data, xx items.count, height_in_items); }
ImGui_ListBox :: (label : *u8, current_item : *s32, items_getter : (data : *void, idx : s32, out_text : **u8) -> bool #c_call, items_count : s32, height_in_items : s32 = -1) -> bool #foreign imgui "?ListBox@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";
// use if you want to reimplement ListBox() will custom data or interactions. if the function return true, you can output elements then call ListBoxFooter() afterwards.
ImGui_ListBoxHeader :: inline (label : *u8, size : ImVec2 = .{ 0, 0 }) -> bool { return ImGui__ListBoxHeader (label, *size); }
ImGui_ListBoxHeader :: (label : *u8, items_count : s32, height_in_items : s32 = -1) -> bool #foreign imgui "?ListBoxHeader@ImGui@@YA_NPEBDHH@Z";
ImGui_ListBoxFooter :: () #foreign imgui "?ListBoxFooter@ImGui@@YAXXZ";

ImGui__ListBox :: (label : *u8, current_item : *s32, items : **u8, items_count : s32, height_in_items : s32 = -1) -> bool #foreign imgui "?ListBox@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";
ImGui__ListBoxHeader :: (label : *u8, const_ref_size : *ImVec2) -> bool #foreign imgui "?ListBoxHeader@ImGui@@YA_NPEBDAEBUImVec2@@@Z";

// Widgets: Data Plotting
ImGui_PlotLines :: inline (label : *u8, values : []float, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) { ImGui__PlotLines (label, values.data, xx values.count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride); }
ImGui_PlotLines :: (label : *u8, values_getter : (data : *void, idx : s32) -> float #c_call, data : *void, values_count : s32, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) #foreign imgui "?PlotLines@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";
ImGui_PlotHistogram :: inline (label : *u8, values : []float, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) { ImGui__PlotHistogram (label, values.data, xx values.count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride); }
ImGui_PlotHistogram :: (label : *u8, values_getter : (data : *void, idx : s32) -> float #c_call, data : *void, values_count : s32, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) #foreign imgui "?PlotHistogram@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";

ImGui__PlotLines :: (label : *u8, values : *float, values_count : s32, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) #foreign imgui "?PlotLines@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";
ImGui__PlotHistogram :: (label : *u8, values : *float, values_count : s32, values_offset : s32 = 0, overlay_text : *u8 = null, scale_min : float = Math.FLOAT32_MAX, scale_max : float = Math.FLOAT32_MAX, graph_size : ImVec2 = .{ 0, 0 }, stride : s32 = size_of (float)) #foreign imgui "?PlotHistogram@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";

// Widgets: Value() Helpers.
// - Those are merely shortcut to calling Text() with a format string. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
ImGui_Value :: (prefix : *u8, b : bool) #foreign imgui "?Value@ImGui@@YAXPEBD_N@Z";
ImGui_Value :: (prefix : *u8, v : s32) #foreign imgui "?Value@ImGui@@YAXPEBDH@Z";
ImGui_Value :: (prefix : *u8, v : u32) #foreign imgui "?Value@ImGui@@YAXPEBDI@Z";
ImGui_Value :: (prefix : *u8, v : float, float_format : *u8 = null) #foreign imgui "?Value@ImGui@@YAXPEBDM0@Z";

// Widgets: Menus
// - Use BeginMenuBar() on a window ImGuiWindowFlags_MenuBar to append to its menu bar.
// - Use BeginMainMenuBar() to create a menu bar at the top of the screen and append to it.
// - Use BeginMenu() to create a menu. You can call BeginMenu() multiple time with the same identifier to append more items to it.
// append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set on parent window).
ImGui_BeginMenuBar :: () -> bool #foreign imgui "?BeginMenuBar@ImGui@@YA_NXZ";
// only call EndMenuBar() if BeginMenuBar() returns true!
ImGui_EndMenuBar :: () #foreign imgui "?EndMenuBar@ImGui@@YAXXZ";
// create and append to a full screen menu-bar.
ImGui_BeginMainMenuBar :: () -> bool #foreign imgui "?BeginMainMenuBar@ImGui@@YA_NXZ";
// only call EndMainMenuBar() if BeginMainMenuBar() returns true!
ImGui_EndMainMenuBar :: () #foreign imgui "?EndMainMenuBar@ImGui@@YAXXZ";
// create a sub-menu entry. only call EndMenu() if this returns true!
ImGui_BeginMenu :: (label : *u8, enabled : bool = true) -> bool #foreign imgui "?BeginMenu@ImGui@@YA_NPEBD_N@Z";
// only call EndMenu() if BeginMenu() returns true!
ImGui_EndMenu :: () #foreign imgui "?EndMenu@ImGui@@YAXXZ";
// return true when activated. shortcuts are displayed for convenience but not processed by ImGui at the moment
ImGui_MenuItem :: (label : *u8, shortcut : *u8 = null, selected : bool = false, enabled : bool = true) -> bool #foreign imgui "?MenuItem@ImGui@@YA_NPEBD0_N1@Z";
// return true when activated + toggle (*p_selected) if p_selected != NULL
ImGui_MenuItem :: (label : *u8, shortcut : *u8, selected : *bool, enabled : bool = true) -> bool #foreign imgui "?MenuItem@ImGui@@YA_NPEBD0PEA_N_N@Z";

// Tooltips
// - Tooltip are windows following the mouse which do not take focus away.
// begin/append a tooltip window. to create full-featured tooltip (with any kind of items).
ImGui_BeginTooltip :: () #foreign imgui "?BeginTooltip@ImGui@@YAXXZ";
ImGui_EndTooltip :: () #foreign imgui "?EndTooltip@ImGui@@YAXXZ";
// set a text-only tooltip, typically use with ImGui::IsItemHovered(). override any previous call to SetTooltip().
ImGui_SetTooltip :: inline (fmt : string, args : ..Any) { formatted := tprint (fmt, ..args); ImGui__SetTooltip (temp_c_string (formatted)); }

ImGui__SetTooltip :: (c_style_fmt : *u8, args : ..Any) #foreign imgui "?SetTooltip@ImGui@@YAXPEBDZZ";

// Popups, Modals
//  - They block normal mouse hovering detection (and therefore most mouse interactions) behind them.
//  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
//  - Their visibility state (~bool) is held internally instead of being held by the programmer as we are used to with regular Begin*() calls.
//  - The 3 properties above are related: we need to retain popup visibility state in the library because popups may be closed as any time.
//  - You can bypass the hovering restriction by using ImGuiHoveredFlags_AllowWhenBlockedByPopup when calling IsItemHovered() or IsWindowHovered().
//  - IMPORTANT: Popup identifiers are relative to the current ID stack, so OpenPopup and BeginPopup generally needs to be at the same level of the stack.
//    This is sometimes leading to confusing mistakes. May rework this in the future.
// Popups: begin/end functions
//  - BeginPopup(): query popup state, if open start appending into the window. Call EndPopup() afterwards. ImGuiWindowFlags are forwarded to the window.
//  - BeginPopupModal(): block every interactions behind the window, cannot be closed by user, add a dimming background, has a title bar.
// return true if the popup is open, and you can start outputting to it.
ImGui_BeginPopup :: (str_id : *u8, flags : ImGuiWindowFlags = 0) -> bool #foreign imgui "?BeginPopup@ImGui@@YA_NPEBDH@Z";
// return true if the modal is open, and you can start outputting to it.
ImGui_BeginPopupModal :: (name : *u8, open : *bool = null, flags : ImGuiWindowFlags = 0) -> bool #foreign imgui "?BeginPopupModal@ImGui@@YA_NPEBDPEA_NH@Z";
// only call EndPopup() if BeginPopupXXX() returns true!
ImGui_EndPopup :: () #foreign imgui "?EndPopup@ImGui@@YAXXZ";
// Popups: open/close functions
//  - OpenPopup(): set popup state to open. ImGuiPopupFlags are available for opening options.
//  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
//  - CloseCurrentPopup(): use inside the BeginPopup()/EndPopup() scope to close manually.
//  - CloseCurrentPopup() is called by default by Selectable()/MenuItem() when activated (FIXME: need some options).
//  - Use ImGuiPopupFlags_NoOpenOverExistingPopup to avoid opening a popup if there's already one at the same level. This is equivalent to e.g. testing for !IsAnyPopupOpen() prior to OpenPopup().
// call to mark popup as open (don't call every frame!).
ImGui_OpenPopup :: (str_id : *u8, popup_flags : ImGuiPopupFlags = 0) #foreign imgui "?OpenPopup@ImGui@@YAXPEBDH@Z";
// helper to open popup when clicked on last item. return true when just opened. (note: actually triggers on the mouse _released_ event to be consistent with popup behaviors)
ImGui_OpenPopupOnItemClick :: (str_id : *u8 = null, popup_flags : ImGuiPopupFlags = .MouseButtonRight) #foreign imgui "?OpenPopupOnItemClick@ImGui@@YAXPEBDH@Z";
// manually close the popup we have begin-ed into.
ImGui_CloseCurrentPopup :: () #foreign imgui "?CloseCurrentPopup@ImGui@@YAXXZ";
// Popups: open+begin combined functions helpers
//  - Helpers to do OpenPopup+BeginPopup where the Open action is triggered by e.g. hovering an item and right-clicking.
//  - They are convenient to easily create context menus, hence the name.
//  - IMPORTANT: Notice that BeginPopupContextXXX takes ImGuiPopupFlags just like OpenPopup() and unlike BeginPopup(). For full consistency, we may add ImGuiWindowFlags to the BeginPopupContextXXX functions in the future.
//  - IMPORTANT: we exceptionally default their flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter, so if you add other flags remember to re-add the ImGuiPopupFlags_MouseButtonRight.
// open+begin popup when clicked on last item. if you can pass a NULL str_id only if the previous item had an id. If you want to use that on a non-interactive item such as Text() you need to pass in an explicit ID here. read comments in .cpp!
ImGui_BeginPopupContextItem :: (str_id : *u8 = null, popup_flags : ImGuiPopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextItem@ImGui@@YA_NPEBDH@Z";
// open+begin popup when clicked on current window.
ImGui_BeginPopupContextWindow :: (str_id : *u8 = null, popup_flags : ImGuiPopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextWindow@ImGui@@YA_NPEBDH@Z";
// open+begin popup when clicked in void (where there are no windows).
ImGui_BeginPopupContextVoid :: (str_id : *u8 = null, popup_flags : ImGuiPopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextVoid@ImGui@@YA_NPEBDH@Z";
// Popups: test function
//  - IsPopupOpen(): return true if the popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId: return true if any popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId + ImGuiPopupFlags_AnyPopupLevel: return true if any popup is open.
ImGui_IsPopupOpen :: (str_id : *u8, popup_flags : ImGuiPopupFlags = 0) -> bool #foreign imgui "?IsPopupOpen@ImGui@@YA_NPEBDH@Z";

// Columns
// - You can also use SameLine(pos_x) to mimic simplified columns.
// - The columns API is work-in-progress and rather lacking (columns are arguably the worst part of dear imgui at the moment!)
// - There is a maximum of 64 columns.
// - Currently working on new 'Tables' api which will replace columns around Q2 2020 (see GitHub #2957).
ImGui_Columns :: (count : s32 = 1, id : *u8 = null, border : bool = true) #foreign imgui "?Columns@ImGui@@YAXHPEBD_N@Z";
// next column, defaults to current row or next row if the current row is finished
ImGui_NextColumn :: () #foreign imgui "?NextColumn@ImGui@@YAXXZ";
// get current column index
ImGui_GetColumnIndex :: () -> s32 #foreign imgui "?GetColumnIndex@ImGui@@YAHXZ";
// get column width (in pixels). pass -1 to use current column
ImGui_GetColumnWidth :: (column_index : s32 = -1) -> float #foreign imgui "?GetColumnWidth@ImGui@@YAMH@Z";
// set column width (in pixels). pass -1 to use current column
ImGui_SetColumnWidth :: (column_index : s32, width : float) #foreign imgui "?SetColumnWidth@ImGui@@YAXHM@Z";
// get position of column line (in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetColumnsCount() inclusive. column 0 is typically 0.0f
ImGui_GetColumnOffset :: (column_index : s32 = -1) -> float #foreign imgui "?GetColumnOffset@ImGui@@YAMH@Z";
// set position of column line (in pixels, from the left side of the contents region). pass -1 to use current column
ImGui_SetColumnOffset :: (column_index : s32, offset_x : float) #foreign imgui "?SetColumnOffset@ImGui@@YAXHM@Z";
ImGui_GetColumnsCount :: () -> s32 #foreign imgui "?GetColumnsCount@ImGui@@YAHXZ";

// Tab Bars, Tabs
// create and append into a TabBar
ImGui_BeginTabBar :: (str_id : *u8, flags : ImGuiTabBarFlags = 0) -> bool #foreign imgui "?BeginTabBar@ImGui@@YA_NPEBDH@Z";
// only call EndTabBar() if BeginTabBar() returns true!
ImGui_EndTabBar :: () #foreign imgui "?EndTabBar@ImGui@@YAXXZ";
// create a Tab. Returns true if the Tab is selected.
ImGui_BeginTabItem :: (label : *u8, open : *bool = null, flags : ImGuiTabItemFlags = 0) -> bool #foreign imgui "?BeginTabItem@ImGui@@YA_NPEBDPEA_NH@Z";
// only call EndTabItem() if BeginTabItem() returns true!
ImGui_EndTabBarItem :: () #foreign imgui "?EndTabItem@ImGui@@YAXXZ";
// create a Tab behaving like a button. return true when clicked. cannot be selected in the tab bar.
ImGui_TabItemButton :: (label : *u8, flags : ImGuiTabItemFlags = 0) -> bool #foreign imgui "?TabItemButton@ImGui@@YA_NPEBDH@Z";
// notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars). For tab-bar: call after BeginTabBar() and before Tab submissions. Otherwise call with a window name.
ImGui_SetTabItemClosed :: (tab_or_docked_window_label : *u8) #foreign imgui "?SetTabItemClosed@ImGui@@YAXPEBD@Z";

// Logging/Capture
// - All text output from the interface can be captured into tty/file/clipboard. By default, tree nodes are automatically opened during logging.
// start logging to tty (stdout)
ImGui_LogToTTY :: (auto_open_depth : s32 = -1) #foreign imgui "?LogToTTY@ImGui@@YAXH@Z";
// start logging to file
ImGui_LogToFile :: (auto_open_depth : s32 = -1, filename : *u8 = null) #foreign imgui "?LogToFile@ImGui@@YAXHPEBD@Z";
// start logging to OS clipboard
ImGui_LogToClipboard :: (auto_open_depth : s32 = -1) #foreign imgui "?LogToClipboard@ImGui@@YAXH@Z";
// stop logging (close file, etc.)
ImGui_LogFinish :: () #foreign imgui "?LogFinish@ImGui@@YAXXZ";
// helper to display buttons for logging to tty/file/clipboard
ImGui_LogButtons :: () #foreign imgui "?LogButtons@ImGui@@YAXXZ";
// pass text data straight to log (without being displayed)
ImGui_LogText :: inline (fmt : string, args : ..Any) { formatted := tprint (fmt, ..args); ImGui__LogText (temp_c_string (formatted)); }

ImGui__LogText :: (c_style_fmt : *u8, args : ..Any) #foreign imgui "?LogText@ImGui@@YAXPEBDZZ";

// Drag and Drop
// - [BETA API] API may evolve!
// - If you stop calling BeginDragDropSource() the payload is preserved however it won't have a preview tooltip (we currently display a fallback "..." tooltip as replacement)
// call when the current item is active. If this return true, you can call SetDragDropPayload() + EndDragDropSource()
ImGui_BeginDragDropSource :: (flags : ImGuiDragDropFlags = 0) -> bool #foreign imgui "?BeginDragDropSource@ImGui@@YA_NH@Z";
// type is a user defined string of maximum 32 characters. Strings starting with '_' are reserved for dear imgui internal types. Data is copied and held by imgui.
ImGui_SetDragDropPayload :: (type : *u8, data : *void, size : u64, cond : ImGuiCond = 0) -> bool #foreign imgui "?SetDragDropPayload@ImGui@@YA_NPEBDPEBX_KH@Z";
// only call EndDragDropSource() if BeginDragDropSource() returns true!
ImGui_EndDragDropSource :: () #foreign imgui "?EndDragDropSource@ImGui@@YAXXZ";
// call after submitting an item that may receive a payload. If this returns true, you can call AcceptDragDropPayload() + EndDragDropTarget()
ImGui_BeginDragDropTarget :: () -> bool #foreign imgui "?BeginDragDropTarget@ImGui@@YA_NXZ";
// accept contents of a given type. If ImGuiDragDropFlags_AcceptBeforeDelivery is set you can peek into the payload before the mouse button is released.
ImGui_AcceptDragDropPayload :: (type : *u8, flags : ImGuiDragDropFlags = 0) -> *ImGuiPayload #foreign imgui "?AcceptDragDropPayload@ImGui@@YAPEBUImGuiPayload@@PEBDH@Z";
// only call EndDragDropTarget() if BeginDragDropTarget() returns true!
ImGui_EndDragDropTarget :: () #foreign imgui "?EndDragDropTarget@ImGui@@YAXXZ";
// peek directly into the current payload from anywhere. may return NULL. use ImGuiPayload::IsDataType() to test for the payload type.
ImGui_GetDragDropPayload :: () -> *ImGuiPayload #foreign imgui "?GetDragDropPayload@ImGui@@YAPEBUImGuiPayload@@XZ";

// Clipping
ImGui_PushClipRect :: inline (clip_rect_min : ImVec2, clip_rect_max : ImVec2, intersect_with_current_clip_rect : bool) { ImGui__PushClipRect (*clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect); }
ImGui_PopClipRect :: () #foreign imgui "?PopClipRect@ImGui@@YAXXZ";

ImGui__PushClipRect :: (const_ref_clip_rect_min : *ImVec2, const_ref_clip_rect_max : *ImVec2, intersect_with_current_clip_rect : bool) #foreign imgui "?PushClipRect@ImGui@@YAXAEBUImVec2@@0_N@Z";

// Focus, Activation
// - Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHereY()" when applicable to signify "this is the default item"
// make last item the default focused item of a window.
ImGui_SetItemDefaultFocus :: () #foreign imgui "?SetItemDefaultFocus@ImGui@@YAXXZ";
// focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.
ImGui_SetKeyboardFocusHere :: (offset : s32 = 0) #foreign imgui "?SetKeyboardFocusHere@ImGui@@YAXH@Z";

// Item/Widgets Utilities
// - Most of the functions are referring to the last/previous item we submitted.
// - See Demo Window under "Widgets->Querying Status" for an interactive visualization of most of those functions.
// is the last item hovered? (and usable, aka not blocked by a popup, etc.). See ImGuiHoveredFlags for more options.
ImGui_IsItemHovered :: (flags : ImGuiHoveredFlags = 0) -> bool #foreign imgui "?IsItemHovered@ImGui@@YA_NH@Z";
// is the last item active? (e.g. button being held, text field being edited. This will continuously return true while holding mouse button on an item. Items that don't interact will always return false)
ImGui_IsItemActive :: () -> bool #foreign imgui "?IsItemActive@ImGui@@YA_NXZ";
// is the last item focused for keyboard/gamepad navigation?
ImGui_IsItemFocused :: () -> bool #foreign imgui "?IsItemFocused@ImGui@@YA_NXZ";
// is the last item clicked? (e.g. button/node just clicked on) == IsMouseClicked(mouse_button) && IsItemHovered()
ImGui_IsItemClicked :: (mouse_button : ImGuiMouseButton = 0) -> bool #foreign imgui "?IsItemClicked@ImGui@@YA_NH@Z";
// is the last item visible? (items may be out of sight because of clipping/scrolling)
ImGui_IsItemVisible :: () -> bool #foreign imgui "?IsItemVisible@ImGui@@YA_NXZ";
// did the last item modify its underlying value this frame? or was pressed? This is generally the same as the "bool" return value of many widgets.
ImGui_IsItemEdited :: () -> bool #foreign imgui "?IsItemEdited@ImGui@@YA_NXZ";
// was the last item just made active (item was previously inactive).
ImGui_IsItemActivated :: () -> bool #foreign imgui "?IsItemActivated@ImGui@@YA_NXZ";
// was the last item just made inactive (item was previously active). Useful for Undo/Redo patterns with widgets that requires continuous editing.
ImGui_IsItemDeactivated :: () -> bool #foreign imgui "?IsItemDeactivated@ImGui@@YA_NXZ";
// was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved). Useful for Undo/Redo patterns with widgets that requires continuous editing. Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).
ImGui_IsItemDeactivatedAfterEdit :: () -> bool #foreign imgui "?IsItemDeactivatedAfterEdit@ImGui@@YA_NXZ";
// was the last item open state toggled? set by TreeNode().
ImGui_IsItemToggledOpen :: () -> bool #foreign imgui "?IsItemToggledOpen@ImGui@@YA_NXZ";
ImGui_IsAnyItemHovered :: () -> bool #foreign imgui "?IsAnyItemHovered@ImGui@@YA_NXZ";
ImGui_IsAnyItemActive :: () -> bool #foreign imgui "?IsAnyItemActive@ImGui@@YA_NXZ";
ImGui_IsAnyItemFocused :: () -> bool #foreign imgui "?IsAnyItemFocused@ImGui@@YA_NXZ";
// get upper-left bounding rectangle of the last item (screen space)
ImGui_GetItemRectMin :: () -> ImVec2 #foreign imgui "?GetItemRectMin@ImGui@@YA?AUImVec2@@XZ";
// get lower-right bounding rectangle of the last item (screen space)
ImGui_GetItemRectMax :: () -> ImVec2 #foreign imgui "?GetItemRectMax@ImGui@@YA?AUImVec2@@XZ";
// get size of last item
ImGui_GetItemRectSize :: () -> ImVec2 #foreign imgui "?GetItemRectSize@ImGui@@YA?AUImVec2@@XZ";
// allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
ImGui_SetItemAllowOverlap :: () #foreign imgui "?SetItemAllowOverlap@ImGui@@YAXXZ";

// Miscellaneous Utilities
// test if rectangle (of given size, starting from cursor position) is visible / not clipped.
ImGui_IsRectVisible :: inline (size : ImVec2) -> bool { return ImGui__IsRectVisible (*size); }
// test if rectangle (in screen space) is visible / not clipped. to perform coarse clipping on user's side.
ImGui_IsRectVisible :: inline (rect_min : ImVec2, rect_max : ImVec2) -> bool { return ImGui__IsRectVisible (*rect_min, *rect_max); }
// get global imgui time. incremented by io.DeltaTime every frame.
ImGui_GetTime :: () -> float64 #foreign imgui "?GetTime@ImGui@@YANXZ";
// get global imgui frame count. incremented by 1 every frame.
ImGui_GetFrameCount :: () -> s32 #foreign imgui "?GetFrameCount@ImGui@@YAHXZ";
// this draw list will be the first rendering one. Useful to quickly draw shapes/text behind dear imgui contents.
ImGui_GetBackgroundDrawList :: () -> *ImDrawList #foreign imgui "?GetBackgroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
// this draw list will be the last rendered one. Useful to quickly draw shapes/text over dear imgui contents.
ImGui_GetForegroundDrawList :: () -> *ImDrawList #foreign imgui "?GetForegroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
// you may use this when creating your own ImDrawList instances.
ImGui_GetDrawListSharedData :: () -> *ImDrawListSharedData #foreign imgui "?GetDrawListSharedData@ImGui@@YAPEAUImDrawListSharedData@@XZ";
// get a string corresponding to the enum value (for display, saving, etc.).
ImGui_GetStyleColorName :: (idx : ImGuiCol) -> *u8 #foreign imgui "?GetStyleColorName@ImGui@@YAPEBDH@Z";
// replace current window storage with our own (if you want to manipulate it yourself, typically clear subsection of it)
ImGui_SetStateStorage :: (storage : *ImGuiStorage) #foreign imgui "?GetStateStorage@ImGui@@YAPEAUImGuiStorage@@XZ";
ImGui_GetStateStorage :: () -> *ImGuiStorage #foreign imgui "?SetStateStorage@ImGui@@YAXPEAUImGuiStorage@@@Z";
// calculate coarse clipping for large list of evenly sized items. Prefer using the ImGuiListClipper higher-level helper if you can.
ImGui_CalcListClipping :: (items_count : s32, items_height : float, out_items_display_start : *s32, out_items_display_end : *s32) #foreign imgui "?CalcListClipping@ImGui@@YAXHMPEAH0@Z";
// helper to create a child window / scrolling region that looks like a normal widget frame
ImGui_BeginChildFrame :: inline (id : ImGuiID, size : ImVec2, flags : ImGuiWindowFlags = 0) -> bool { return ImGui__BeginChildFrame (id, *size, flags); }
// always call EndChildFrame() regardless of BeginChildFrame() return values (which indicates a collapsed/clipped window)
ImGui_EndChildFrame :: () #foreign imgui "?EndChildFrame@ImGui@@YAXXZ";

ImGui__IsRectVisible :: (const_ref_size : *ImVec2) -> bool #foreign imgui "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@@Z";
ImGui__IsRectVisible :: (const_ref_rect_min : *ImVec2, const_ref_rect_max : *ImVec2) -> bool #foreign imgui "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@0@Z";
ImGui__BeginChildFrame :: (id : ImGuiID, const_ref_size : *ImVec2, flags : ImGuiWindowFlags) -> bool #foreign imgui "?BeginChildFrame@ImGui@@YA_NIAEBUImVec2@@H@Z";

// Text Utilities
ImGui_CalcTextSize :: (text : *u8, text_end : *u8 = null, hide_text_after_double_hash : bool = false, wrap_width : float = -1) -> ImVec2 #foreign imgui "?CalcTextSize@ImGui@@YA?AUImVec2@@PEBD0_NM@Z";
ImGui_CalcTextSize :: inline (text : string, hide_text_after_double_hash : bool = false, wrap_width : float = -1) -> ImVec2 { return ImGui_CalcTextSize (text.data, text.data + text.count, hide_text_after_double_hash, wrap_width); }

// Color Utilities
ImGui_ColorConvertU32ToFloat4 :: (in : u32) -> ImVec4 #foreign imgui "?ColorConvertU32ToFloat4@ImGui@@YA?AUImVec4@@I@Z";
ImGui_ColorConvertFloat4ToU32 :: inline (in : ImVec4) -> u32 { return ImGui__ColorConvertFloat4ToU32 (*in); }
ImGui_ColorRGBToHSV :: (r : float, g : float, b : float, out_h : *float, out_s : *float, out_v : *float) #foreign imgui "?ColorConvertRGBtoHSV@ImGui@@YAXMMMAEAM00@Z";
ImGui_ColorHSVToRGB :: (h : float, s : float, v : float, out_r : *float, out_g : *float, out_b : *float) #foreign imgui "?ColorConvertHSVtoRGB@ImGui@@YAXMMMAEAM00@Z";

ImGui__ColorConvertFloat4ToU32 :: (const_ref_in : *ImVec4) -> u32 #foreign imgui "?ColorConvertFloat4ToU32@ImGui@@YAIAEBUImVec4@@@Z";

// Inputs Utilities: Keyboard
// - For 'int user_key_index' you can use your own indices/enums according to how your back-end/engine stored them in io.KeysDown[].
// - We don't know the meaning of those value. You can use GetKeyIndex() to map a ImGuiKey_ value into the user index.
// map ImGuiKey_* values into user's key index. == io.KeyMap[key]
ImGui_GetKeyIndex :: (imgui_key : ImGuiKey) -> s32 #foreign imgui "?GetKeyIndex@ImGui@@YAHH@Z";
// is key being held. == io.KeysDown[user_key_index].
ImGui_IsKeyDown :: (user_key_index : s32) -> bool #foreign imgui "?IsKeyDown@ImGui@@YA_NH@Z";
// was key pressed (went from !Down to Down)? if repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate
ImGui_IsKeyPressed :: (user_key_index : s32, repeat : bool = false) -> bool #foreign imgui "?IsKeyPressed@ImGui@@YA_NH_N@Z";
// was key released (went from Down to !Down)?
ImGui_IsKeyReleased :: (user_key_index : s32) -> bool #foreign imgui "?IsKeyReleased@ImGui@@YA_NH@Z";
// uses provided repeat rate/delay. return a count, most often 0 or 1 but might be >1 if RepeatRate is small enough that DeltaTime > RepeatRate
ImGui_GetKeyPressedAmount :: (key_index : s32, repeat_delay : float, rate : float) -> s32 #foreign imgui "?GetKeyPressedAmount@ImGui@@YAHHMM@Z";
// attention: misleading name! manually override io.WantCaptureKeyboard flag next frame (said flag is entirely left for your application to handle). e.g. force capture keyboard when your widget is being hovered. This is equivalent to setting "io.WantCaptureKeyboard = want_capture_keyboard_value"; after the next NewFrame() call.
ImGui_CaptureKeyboardFromApp :: (want_capture_keyboard_value : bool = true) #foreign imgui "?CaptureKeyboardFromApp@ImGui@@YAX_N@Z";

// Inputs Utilities: Mouse
// - To refer to a mouse button, you may use named enums in your code e.g. ImGuiMouseButton_Left, ImGuiMouseButton_Right.
// - You can also use regular integer: it is forever guaranteed that 0=Left, 1=Right, 2=Middle.
// - Dragging operations are only reported after mouse has moved a certain distance away from the initial clicking position (see 'lock_threshold' and 'io.MouseDraggingThreshold')
ImGui_IsMouseDown :: (button : ImGuiMouseButton) -> bool #foreign imgui "?IsMouseDown@ImGui@@YA_NH@Z";
ImGui_IsMouseClicked :: (button : ImGuiMouseButton, repeat : bool = false) -> bool #foreign imgui "?IsMouseClicked@ImGui@@YA_NH_N@Z";
ImGui_IsMouseReleased :: (button : ImGuiMouseButton) -> bool #foreign imgui "?IsMouseReleased@ImGui@@YA_NH@Z";
// did mouse button double-clicked? (note that a double-click will also report IsMouseClicked() == true)
ImGui_IsMouseDoubleClicked :: (button : ImGuiMouseButton) -> bool #foreign imgui "?IsMouseDoubleClicked@ImGui@@YA_NH@Z";
// is mouse hovering given bounding rect (in screen space). clipped by current clipping settings, but disregarding of other consideration of focus/window ordering/popup-block.
ImGui_IsMouseHoveringRect :: inline (min : ImVec2, max : ImVec2, clip : bool = true) -> bool { return ImGui__IsMouseHoveringRect (*min, *max, clip); }
// by convention we use (-FLT_MAX,-FLT_MAX) to denote that there is no mouse available
ImGui_IsMousePosValid :: (mouse_pos : *ImVec2 = null) -> bool #foreign imgui "?IsMousePosValid@ImGui@@YA_NPEBUImVec2@@@Z";
ImGui_IsAnyMouseDown :: () -> bool #foreign imgui "?IsAnyMouseDown@ImGui@@YA_NXZ";
// shortcut to ImGui::GetIO().MousePos provided by user, to be consistent with other calls
ImGui_GetMousePos :: () -> ImVec2 #foreign imgui "?GetMousePos@ImGui@@YA?AUImVec2@@XZ";
// retrieve mouse position at the time of opening popup we have BeginPopup() into (helper to avoid user backing that value themselves)
ImGui_GetMousePosOnOpeningCurrentPopup :: () -> ImVec2 #foreign imgui "?GetMousePosOnOpeningCurrentPopup@ImGui@@YA?AUImVec2@@XZ";
// is mouse dragging? (if lock_threshold < -1.0f, uses io.MouseDraggingThreshold)
ImGui_IsMouseDragging :: (button : ImGuiMouseButton, lock_threshold : float = -1) -> bool #foreign imgui "?IsMouseDragging@ImGui@@YA_NHM@Z";
// return the delta from the initial clicking position while the mouse button is pressed or was just released. This is locked and return 0.0f until the mouse moves past a distance threshold at least once (if lock_threshold < -1.0f, uses io.MouseDraggingThreshold)
ImGui_GetMouseDragDelta :: (button : ImGuiMouseButton = 0, lock_threshold : float = -1) -> ImVec2 #foreign imgui "?GetMouseDragDelta@ImGui@@YA?AUImVec2@@HM@Z";
ImGui_ResetMouseDragDelta :: (button : ImGuiMouseButton = 0) #foreign imgui "?ResetMouseDragDelta@ImGui@@YAXH@Z";
// get desired cursor type, reset in ImGui::NewFrame(), this is updated during the frame. valid before Render(). If you use software rendering by setting io.MouseDrawCursor ImGui will render those for you
ImGui_GetMouseCursor :: () -> ImGuiMouseCursor #foreign imgui "?GetMouseCursor@ImGui@@YAHXZ";
ImGui_SetMouseCursor :: (cursor_type : ImGuiMouseCursor) #foreign imgui "?SetMouseCursor@ImGui@@YAXH@Z";
// attention: misleading name! manually override io.WantCaptureMouse flag next frame (said flag is entirely left for your application to handle). This is equivalent to setting "io.WantCaptureMouse = want_capture_mouse_value;" after the next NewFrame() call.
ImGui_CaptureMouseFromApp :: (want_capture_mouse_value : bool = true) #foreign imgui "?CaptureMouseFromApp@ImGui@@YAX_N@Z";

ImGui__IsMouseHoveringRect :: (const_ref_min : *ImVec2, const_ref_max : *ImVec2, clip : bool = true) -> bool #foreign imgui "?IsMouseHoveringRect@ImGui@@YA_NAEBUImVec2@@0_N@Z";

// Clipboard Utilities
// - Also see the LogToClipboard() function to capture GUI into clipboard, or easily output text data to the clipboard.
ImGui_GetClipboardText :: () -> *u8 #foreign imgui "?GetClipboardText@ImGui@@YAPEBDXZ";
ImGui_SetClipboardText :: (text : *u8) #foreign imgui "?SetClipboardText@ImGui@@YAXPEBD@Z";

// Settings/.Ini Utilities
// - The disk functions are automatically called if io.IniFilename != NULL (default is "imgui.ini").
// - Set io.IniFilename to NULL to load/save manually. Read io.WantSaveIniSettings description about handling .ini saving manually.
// call after CreateContext() and before the first call to NewFrame(). NewFrame() automatically calls LoadIniSettingsFromDisk(io.IniFilename).
ImGui_LoadIniSettingsFromDisk :: (ini_filename : *u8) #foreign imgui "?LoadIniSettingsFromDisk@ImGui@@YAXPEBD@Z";
// call after CreateContext() and before the first call to NewFrame() to provide .ini data from your own data source.
ImGui_LoadIniSettingsFromMemory :: (init_data : *u8, ini_size : u64 = 0) #foreign imgui "?LoadIniSettingsFromMemory@ImGui@@YAXPEBD_K@Z";
// this is automatically called (if io.IniFilename is not empty) a few seconds after any modification that should be reflected in the .ini file (and also by DestroyContext).
ImGui_SaveIniSettingsToDisk :: (ini_filename : *u8) #foreign imgui "?SaveIniSettingsToDisk@ImGui@@YAXPEBD@Z";
// return a zero-terminated string with the .ini data which you can save by your own mean. call when io.WantSaveIniSettings is set, then save data by your own mean and clear io.WantSaveIniSettings.
ImGui_SaveIniSettingsToMemory :: (out_ini_size : *u64 = null) -> *u8 #foreign imgui "?SaveIniSettingsToMemory@ImGui@@YAPEBDPEA_K@Z";

// Debug Utilities
ImGui_DebugCheckVersionAndDataLayout :: (version_str : *u8, sz_io : u64, sz_style : u64, sz_vec2 : u64, sz_vec4 : u64, sz_drawvert : u64, sz_drawidx : u64) -> bool #foreign imgui "?DebugCheckVersionAndDataLayout@ImGui@@YA_NPEBD_K11111@Z";

// Memory Allocators
// - All those functions are not reliant on the current context.
// - If you reload the contents of imgui.cpp at runtime, you may need to call SetCurrentContext() + SetAllocatorFunctions() again because we use global storage for those.
ImGui_SetAllocatorFunctions :: (alloc_func : (size : u64, user_data : *void) -> *void, free_fun : (ptr : *void, user_data : *void) -> void, user_data : *void = null) #foreign imgui "?SetAllocatorFunctions@ImGui@@YAXP6APEAX_KPEAX@ZP6AX11@Z1@Z";
ImGui_MemAlloc :: (size : u64) -> *void #foreign imgui "?MemAlloc@ImGui@@YAPEAX_K@Z";
ImGui_MemFree :: (ptr : *void) #foreign imgui "?MemFree@ImGui@@YAXPEAX@Z";

// ====================================
//    ImGuiStyle member functions
// ====================================

ImGuiStyle_ScaleAllSizes :: (this : *ImGuiStyle, scale_factor : float) #foreign imgui "?ScaleAllSizes@ImGuiStyle@@QEAAXM@Z";

// ====================================
//      ImGuiIO member functions
// ====================================

// Queue new character input
ImGuiIO_AddInputCharacter :: (this : *ImGuiIO, c : u32) #foreign imgui "?AddInputCharacter@ImGuiIO@@QEAAXI@Z";
// Queue new character input from an UTF-16 character, it can be a surrogate
ImGuiIO_AddInputCharacterUTF16 :: (this : *ImGuiIO, c : u16) #foreign imgui "?AddInputCharacterUTF16@ImGuiIO@@QEAAXG@Z";
// Queue new characters input from an UTF-8 string
ImGuiIO_AddInputCharactersUTF8 :: (this : *ImGuiIO, str : *u8) #foreign imgui "?AddInputCharactersUTF8@ImGuiIO@@QEAAXPEBD@Z";
// Clear the text input buffer manually
ImGuiIO_ClearInputCharacters :: (this : *ImGuiIO) #foreign imgui "?ClearInputCharacters@ImGuiIO@@QEAAXXZ";

// =============================================
// ImGuiInputTextCallbackData member functions
// =============================================

ImGuiInputTextCallbackData_DeleteChars :: (this : *ImGuiInputTextCallbackData, pos : s32, bytes_count : s32) #foreign imgui "?DeleteChars@ImGuiInputTextCallbackData@@QEAAXHH@Z";
ImGuiInputTextCallbackData_InsertChars :: (this : *ImGuiInputTextCallbackData, pos : s32, text : *u8, text_end : *u8 = null) #foreign imgui "?InsertChars@ImGuiInputTextCallbackData@@QEAAXHPEBD0@Z";
//void                SelectAll()             { SelectionStart = 0; SelectionEnd = BufTextLen; }
//void                ClearSelection()        { SelectionStart = SelectionEnd = BufTextLen; }
//bool                HasSelection() const    { return SelectionStart != SelectionEnd; }

// =============================================
//       ImGuiPayload member functions
// =============================================

//void Clear()    { SourceId = SourceParentId = 0; Data = NULL; DataSize = 0; memset(DataType, 0, sizeof(DataType)); DataFrameCount = -1; Preview = Delivery = false; }
//bool IsDataType(const char* type) const { return DataFrameCount != -1 && strcmp(type, DataType) == 0; }
//bool IsPreview() const                  { return Preview; }
//bool IsDelivery() const                 { return Delivery; }

// =============================================
//       ImGuiTextFilter member functions
// =============================================

// Helper calling InputText+Build
ImGuiTextFilter_Draw :: (this : *ImGuiTextFilter, label : *u8 = "Filter (inc,-exc)", width : float = 0) -> bool #foreign imgui "?Draw@ImGuiTextFilter@@QEAA_NPEBDM@Z";
ImGuiTextFilter_PassFilter :: (this : *ImGuiTextFilter, text : *u8, text_end : *u8 = null) -> bool #foreign imgui "?PassFilter@ImGuiTextFilter@@QEBA_NPEBD0@Z";
ImGuiTextFilter_Build :: (this : *ImGuiTextFilter) #foreign imgui "?Build@ImGuiTextFilter@@QEAAXXZ";
//void                Clear()          { InputBuf[0] = 0; Build(); }
//bool                IsActive() const { return !Filters.empty(); }

// =============================================
//       ImGuiListClipper member functions
// =============================================

// Automatically called by constructor if you passed 'items_count' or by Step() in Step 1.
ImGuiListClipper_Begin :: (this : *ImGuiListClipper, items_count : s32, items_height : float = -1) #foreign imgui "?Begin@ImGuiListClipper@@QEAAXHM@Z";
// Automatically called on the last call of Step() that returns false.
ImGuiListCLipper_End :: (this : *ImGuiListClipper) #foreign imgui "?End@ImGuiListClipper@@QEAAXXZ";
// Call until it returns false. The DisplayStart/DisplayEnd fields will be set and you can process/draw those items.
ImGuiListClipper_Step :: (this : *ImGuiListClipper) -> bool #foreign imgui "?Step@ImGuiListClipper@@QEAA_NXZ";

// =============================================
//     ImDrawListSplitter member functions
// =============================================

//inline void                 Clear() { _Current = 0; _Count = 1; } // Do not clear Channels[] so our allocations are reused next frame
ImDrawListSplitter_ClearFreeMemory :: (this : *ImDrawListSplitter) #foreign imgui "?ClearFreeMemory@ImDrawListSplitter@@QEAAXXZ";
ImDrawListSpliiter_Split :: (this : *ImDrawListSplitter, draw_list : *ImDrawList, count : s32) #foreign imgui "?Split@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";
ImDrawListSplitter_Merge :: (this : *ImDrawListSplitter, draw_list : *ImDrawList) #foreign imgui "?Merge@ImDrawListSplitter@@QEAAXPEAUImDrawList@@@Z";
ImDrawListSplitter_SetCurrentChannel :: (this : *ImDrawListSplitter, draw_list : *ImDrawList, channel_idx : s32) #foreign imgui "?SetCurrentChannel@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";

// =============================================
//         ImDrawList member functions
// =============================================

// Render-level scissoring. This is passed down to your render function but not used for CPU-side coarse clipping. Prefer using higher-level ImGui::PushClipRect() to affect logic (hit-testing and widget culling)
ImDrawList_PushClipRect :: (this : *ImDrawList, clip_rect_min : ImVec2, clip_rect_max : ImVec2, intersect_with_current_clip_rect : bool = false) #foreign imgui "?PushClipRect@ImDrawList@@QEAAXUImVec2@@0_N@Z";
ImDrawList_PushClipRectFullscreen :: (this : *ImDrawList) #foreign imgui "?PushClipRectFullScreen@ImDrawList@@QEAAXXZ";
ImDrawList_PopClipRect :: (this : *ImDrawList) #foreign imgui "?PopClipRect@ImDrawList@@QEAAXXZ";
ImDrawList_PushTextureID :: (this : *ImDrawList, texture_id : ImTextureID) #foreign imgui "?PushTextureID@ImDrawList@@QEAAXPEAX@Z";
ImDrawList_PopTextureID :: (this : *ImDrawList) #foreign imgui "?PopTextureID@ImDrawList@@QEAAXXZ";
//inline ImVec2   GetClipRectMin() const { const ImVec4& cr = _ClipRectStack.back(); return ImVec2(cr.x, cr.y); }
//inline ImVec2   GetClipRectMax() const { const ImVec4& cr = _ClipRectStack.back(); return ImVec2(cr.z, cr.w); }

// Primitives
// - For rectangular primitives, "p_min" and "p_max" represent the upper-left and lower-right corners.
// - For circle primitives, use "num_segments == 0" to automatically calculate tessellation (preferred).
//   In older versions (until Dear ImGui 1.77) the AddCircle functions defaulted to num_segments == 12.
//   In future versions we will use textures to provide cheaper and higher-quality circles.
//   Use AddNgon() and AddNgonFilled() functions if you need to guaranteed a specific number of sides.
ImDrawList_AddLine :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, col : u32, thickness : float = 1) { ImDrawList__AddLine (this, *p1, *p2, col, thickness); }
// a: upper-left, b: lower-right (== upper-left + size), rounding_corners_flags: 4 bits corresponding to which corner to round
ImDrawList_AddRect :: inline (this : *ImDrawList, p_min : ImVec2, p_max : ImVec2, col : u32, rounding : float = 0, rounding_corners : ImDrawCornerFlags = .All, thickness : float = 1) { ImDrawList__AddRect (this, *p_min, *p_max, col, rounding, rounding_corners, thickness); }
// a: upper-left, b: lower-right (== upper-left + size)
ImDrawList_AddRectFilled :: inline (this : *ImDrawList, p_min : ImVec2, p_max : ImVec2, col : u32, rounding : float = 0, rounding_corners : ImDrawCornerFlags = .All) { ImDrawList__AddRectFilled (this, *p_min, *p_max, col, rounding, rounding_corners); }
ImDrawList_AddRectFilledMultiColor :: inline (this : *ImDrawList, p_min : ImVec2, p_max : ImVec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) { ImDrawList__AddRectFilledMultiColor (this, *p_min, *p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left); }
ImDrawList_AddQuad :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, p4 : ImVec2, col : u32, thickness : float = 1) { ImDrawList__AddQuad (this, *p1, *p2, *p3, *p4, col, thickness); }
ImDrawList_AddQuadFilled :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, p4 : ImVec2, col : u32) { ImDrawList__AddQuadFilled (this, *p1, *p2, *p3, *p4, col); }
ImDrawList_AddTriangle :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, col : u32, thickness : float = 1) { ImDrawList__AddTriangle (this, *p1, *p2, *p3, col, thickness); }
ImDrawList_AddTriangleFilled :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, col : u32) { ImDrawList__AddTriangleFilled (this, *p1, *p2, *p3, col); }
ImDrawList_AddCircle :: inline (this : *ImDrawList, center : ImVec2, radius : float, col :u32, num_segments : s32 = 0, thickness : float = 1) { ImDrawList__AddCircle (this, *center, radius, col, num_segments, thickness); }
ImDrawList_AddCircleFilled :: inline (this : *ImDrawList, center : ImVec2, radius : float, col :u32, num_segments : s32 = 0) { ImDrawList__AddCircleFilled (this, *center, radius, col, num_segments); }
ImDrawList_AddNgon :: inline (this : *ImDrawList, center : ImVec2, radius : float, col :u32, num_segments : s32, thickness : float = 1) { ImDrawList__AddNgon (this, *center, radius, col, num_segments, thickness); }
ImDrawList_AddNgonFilled :: inline (this : *ImDrawList, center : ImVec2, radius : float, col :u32, num_segments : s32) { ImDrawList__AddNgonFilled (this, *center, radius, col, num_segments); }
ImDrawList_AddText :: inline (this : *ImDrawList, pos : ImVec2, col : u32, text_begin : *u8, text_end : *u8 = null) { ImDrawList__AddText (this, *pos, col, text_begin, text_end); }
ImDrawList_AddText :: inline (this : *ImDrawList, font : *ImFont, font_size : float, pos : ImVec2, col : u32, text_begin : *u8, text_end : *u8 = null, wrap_width : float = 0, cpu_fine_clip_rect : *ImVec4 = null) { ImDrawList__AddText (this, font, font_size, *pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect); }
ImDrawList_AddPolyLine :: inline (this : *ImDrawList, points : []ImVec2, col : u32, closed : bool, thickness : float) { ImDrawList__AddPolyLine (this, points.data, xx points.count, col, closed, thickness); }
ImDrawList_AddConvexPolyFilled :: inline (this : *ImDrawList, points : []ImVec2, col : u32) { ImDrawList__AddConvexPolyFilled (this, points.data, xx points.count, col); }
ImDrawList_AddBezierCurve :: inline (this : *ImDrawList, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, p4 : ImVec2, col : u32, thickness : float, num_segments : s32 = 0) { ImDrawList__AddBezierCurve (this, *p1, *p2, *p3, *p4, col, thickness, num_segments); }

ImDrawList__AddLine :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, col : u32, thickness : float) #foreign imgui "?AddLine@ImDrawList@@QEAAXAEBUImVec2@@0IM@Z";
ImDrawList__AddRect :: (this : *ImDrawList, const_ref_p_min : *ImVec2, const_ref_p_max : *ImVec2, col : u32, rounding : float, rounding_corners : ImDrawCornerFlags, thickness : float) #foreign imgui "?AddRect@ImDrawList@@QEAAXAEBUImVec2@@0IMHM@Z";
ImDrawList__AddRectFilled :: (this : *ImDrawList, const_ref_p_min : *ImVec2, const_ref_p_max : *ImVec2, col : u32, rounding : float, rounding_corners : ImDrawCornerFlags) #foreign imgui "?AddRectFilled@ImDrawList@@QEAAXAEBUImVec2@@0IMH@Z";
ImDrawList__AddRectFilledMultiColor :: (this : *ImDrawList, const_ref_p_min : *ImVec2, const_ref_p_max : *ImVec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) #foreign imgui "?AddRectFilledMultiColor@ImDrawList@@QEAAXAEBUImVec2@@0IIII@Z";
ImDrawList__AddQuad :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, const_ref_p4 : *ImVec2, col : u32, thickness : float) #foreign imgui "?AddQuad@ImDrawList@@QEAAXAEBUImVec2@@000IM@Z";
ImDrawList__AddQuadFilled :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, const_ref_p4 : *ImVec2, col : u32) #foreign imgui "?AddQuadFilled@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
ImDrawList__AddTriangle :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, col : u32, thickness : float) #foreign imgui "?AddTriangle@ImDrawList@@QEAAXAEBUImVec2@@00IM@Z";
ImDrawList__AddTriangleFilled :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, col : u32) #foreign imgui "?AddTriangleFilled@ImDrawList@@QEAAXAEBUImVec2@@00I@Z";
ImDrawList__AddCircle :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, col :u32, num_segments : s32, thickness : float) #foreign imgui "?AddCircle@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
ImDrawList__AddCircleFilled :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, col :u32, num_segments : s32) #foreign imgui "?AddCircleFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
ImDrawList__AddNgon :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, col :u32, num_segments : s32, thickness : float) #foreign imgui "?AddNgon@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
ImDrawList__AddNgonFilled :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, col :u32, num_segments : s32) #foreign imgui "?AddNgonFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
ImDrawList__AddText :: (this : *ImDrawList, const_ref_pos : *ImVec2, col : u32, text_begin : *u8, text_end : *u8) #foreign imgui "?AddText@ImDrawList@@QEAAXAEBUImVec2@@IPEBD1@Z";
ImDrawList__AddText :: (this : *ImDrawList, font : *ImFont, font_size : float, const_ref_pos : *ImVec2, col : u32, text_begin : *u8, text_end : *u8, wrap_width : float, cpu_fine_clip_rect : *ImVec4) #foreign imgui "?AddText@ImDrawList@@QEAAXPEBUImFont@@MAEBUImVec2@@IPEBD2MPEBUImVec4@@@Z";
ImDrawList__AddPolyLine :: (this : *ImDrawList, points : *ImVec2, num_points : s32, col : u32, closed : bool, thickness : float) #foreign imgui "?AddPolyline@ImDrawList@@QEAAXPEBUImVec2@@HI_NM@Z";
ImDrawList__AddConvexPolyFilled :: (this : *ImDrawList, points : *ImVec2, num_points : s32, col : u32) #foreign imgui "?AddConvexPolyFilled@ImDrawList@@QEAAXPEBUImVec2@@HI@Z";
ImDrawList__AddBezierCurve :: (this : *ImDrawList, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, const_ref_p4 : *ImVec2, col : u32, thickness : float, num_segments : s32) #foreign imgui "?AddBezierCurve@ImDrawList@@QEAAXAEBUImVec2@@000IMH@Z";

// Image primitives
// - Read FAQ to understand what ImTextureID is.
// - "p_min" and "p_max" represent the upper-left and lower-right corners of the rectangle.
// - "uv_min" and "uv_max" represent the normalized texture coordinates to use for those corners. Using (0,0)->(1,1) texture coordinates will generally display the entire texture.
ImDrawList_AddImage :: inline (this : *ImDrawList, user_texture_id : ImTextureID, p_min : ImVec2, p_max : ImVec2, uv_min : ImVec2 = .{ 0, 0 }, uv_max : ImVec2 = .{ 1, 1 }, col : u32 = 0xffff_ffff) { ImDrawList__AddImage (this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col); }
ImDrawList_AddImageQuad :: inline (this : *ImDrawList, user_texture_id : ImTextureID, p1 : ImVec2, p2 : ImVec2, p3 : ImVec2, p4 : ImVec2, uv1 : ImVec2 = .{ 0, 0 }, uv2 : ImVec2 = .{ 1, 0 }, uv3 : ImVec2 = .{ 1, 1 }, uv4 : ImVec2 = .{ 0, 1 }, col : u32 = 0xffff_ffff) { ImDrawList__AddImageQuad (this, user_texture_id, *p1, *p2, *p3, *p4, *uv1, *uv2, *uv3, *uv4, col); }
ImDrawList_AddImageRounded :: inline (this : *ImDrawList, user_texture_id : ImTextureID, p_min : ImVec2, p_max : ImVec2, uv_min : ImVec2, uv_max : ImVec2, col : u32, rounding : float, rounding_corners : ImDrawCornerFlags = .All) { ImDrawList__AddImageRounded (this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col, rounding, rounding_corners); }

ImDrawList__AddImage :: (this : *ImDrawList, user_texture_id : ImTextureID, const_ref_p_min : *ImVec2, const_ref_p_max : *ImVec2, const_ref_uv_min : *ImVec2, const_ref_uv_max : *ImVec2, col : u32) #foreign imgui "?AddImage@ImDrawList@@QEAAXPEAXAEBUImVec2@@111I@Z";
ImDrawList__AddImageQuad :: (this : *ImDrawList, user_texture_id : ImTextureID, const_ref_p1 : *ImVec2, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, const_ref_p4 : *ImVec2, const_ref_uv1 : *ImVec2, const_ref_uv2 : *ImVec2, const_ref_uv3 : *ImVec2, const_ref_uv4 : *ImVec2, col : u32) #foreign imgui "?AddImageQuad@ImDrawList@@QEAAXPEAXAEBUImVec2@@1111111I@Z";
ImDrawList__AddImageRounded :: (this : *ImDrawList, user_texture_id : ImTextureID, const_ref_p_min : *ImVec2, const_ref_p_max : *ImVec2, const_ref_uv_min : *ImVec2, const_ref_uv_max : *ImVec2, col : u32, rounding : float, rounding_corners : ImDrawCornerFlags) #foreign imgui "?AddImageRounded@ImDrawList@@QEAAXPEAXAEBUImVec2@@111IMH@Z";

// Stateful path API, add points then finish with PathFillConvex() or PathStroke()
//inline    void  PathClear()                                                 { _Path.Size = 0; }
//inline    void  PathLineTo(const ImVec2& pos)                               { _Path.push_back(pos); }
//inline    void  PathLineToMergeDuplicate(const ImVec2& pos)                 { if (_Path.Size == 0 || memcmp(&_Path.Data[_Path.Size - 1], &pos, 8) != 0) _Path.push_back(pos); }
//inline    void  PathFillConvex(ImU32 col)                                   { AddConvexPolyFilled(_Path.Data, _Path.Size, col); _Path.Size = 0; }  // Note: Anti-aliased filling requires points to be in clockwise order.
//inline    void  PathStroke(ImU32 col, bool closed, float thickness = 1.0f)  { AddPolyline(_Path.Data, _Path.Size, col, closed, thickness); _Path.Size = 0; }
ImDrawList_PathArcTo :: inline (this : *ImDrawList, center : ImVec2, radius : float, a_min : float, a_max : float, num_segments : s32 = 10) { ImDrawList__PathArcTo (this, *center, radius, a_min, a_max, num_segments); }
// Use precomputed angles for a 12 steps circle
ImDrawList_PathArcToFast :: inline (this : *ImDrawList, center : ImVec2, radius : float, a_min_of_12 : s32, a_max_of_12 : s32) { ImDrawList__PathArcToFast (this, *center, radius, a_min_of_12, a_max_of_12); }
ImDrawList_PathBezierCurveTo :: inline (this : *ImDrawList, p2 : ImVec2, p3 : ImVec2, p4 : ImVec4, num_segments : s32 = 0) { ImDrawList__PathBezierCurveTo (this, *p2, *p3, *p4, num_segments); }
//IMGUI_API void  PathRect(const ImVec2& rect_min, const ImVec2& rect_max, float rounding = 0.0f, ImDrawCornerFlags rounding_corners = ImDrawCornerFlags_All);
ImDrawList_PathRect :: inline (this : *ImDrawList, rect_min : ImVec2, rect_max : ImVec2, rounding : float = 0, rounding_corners : ImDrawCornerFlags = .All) { ImDrawList__PathRect (this, *rect_min, *rect_max, rounding, rounding_corners); }

ImDrawList__PathArcTo :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, a_min : float, a_max : float, num_segments : s32) #foreign imgui "?PathArcTo@ImDrawList@@QEAAXAEBUImVec2@@MMMH@Z";
ImDrawList__PathArcToFast :: (this : *ImDrawList, const_ref_center : *ImVec2, radius : float, a_min_of_12 : s32, a_max_of_12 : s32) #foreign imgui "?PathArcToFast@ImDrawList@@QEAAXAEBUImVec2@@MHH@Z";
ImDrawList__PathBezierCurveTo :: (this : *ImDrawList, const_ref_p2 : *ImVec2, const_ref_p3 : *ImVec2, const_ref_p4 : *ImVec4, num_segments : s32) #foreign imgui "?PathBezierCurveTo@ImDrawList@@QEAAXAEBUImVec2@@00H@Z";
ImDrawList__PathRect :: (this : *ImDrawList, const_ref_rect_min : *ImVec2, const_ref_rect_max : *ImVec2, rounding : float, rounding_corners : ImDrawCornerFlags) #foreign imgui "?PathRect@ImDrawList@@QEAAXAEBUImVec2@@0MH@Z";

// Advanced
// Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
ImDrawList_AddCallback :: (this : *ImDrawList, callback : ImDrawCallback, callback_data : *void) #foreign imgui "?AddCallback@ImDrawList@@QEAAXP6AXPEBU1@PEBUImDrawCmd@@@ZPEAX@Z";
// This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
ImDrawList_AddDrawCmd :: (this : *ImDrawList) #foreign imgui "?AddDrawCmd@ImDrawList@@QEAAXXZ";
// Create a clone of the CmdBuffer/IdxBuffer/VtxBuffer.
ImDrawList_CloneOutput :: (this : *ImDrawList) -> *ImDrawList #foreign imgui "?CloneOutput@ImDrawList@@QEBAPEAU1@XZ";

// Advanced: Channels
// - Use to split render into layers. By switching channels to can render out-of-order (e.g. submit FG primitives before BG primitives)
// - Use to minimize draw calls (e.g. if going back-and-forth between multiple clipping rectangles, prefer to append into separate channels then merge at the end)
// - FIXME-OBSOLETE: This API shouldn't have been in ImDrawList in the first place!
//   Prefer using your own persistent instance of ImDrawListSplitter as you can stack them.
//   Using the ImDrawList::ChannelsXXXX you cannot stack a split over another.
//inline void     ChannelsSplit(int count)    { _Splitter.Split(this, count); }
//inline void     ChannelsMerge()             { _Splitter.Merge(this); }
//inline void     ChannelsSetCurrent(int n)   { _Splitter.SetCurrentChannel(this, n); }

// Advanced: Primitives allocations
// - We render triangles (three vertices)
// - All primitives needs to be reserved via PrimReserve() beforehand.
ImDrawList_PrimReserve :: (this : *ImDrawList, idx_count : s32, vtx_count : s32) #foreign imgui "?PrimReserve@ImDrawList@@QEAAXHH@Z";
ImDrawList_PrimUnreserve :: (this : *ImDrawList, idx_count : s32, vtx_count : s32) #foreign imgui "?PrimUnreserve@ImDrawList@@QEAAXHH@Z";
// Axis aligned rectangle (composed of two triangles)
ImDrawList_PrimRect :: inline (this : *ImDrawList, a : ImVec2, b : ImVec2, col : u32) { ImDrawList__PrimRect (this, *a, *b, col); }
ImDrawList_PrimRectUV :: inline (this : *ImDrawList, a : ImVec2, b : ImVec2, uv_a : ImVec2, uv_b : ImVec2, col : u32) { ImDrawList__PrimRectUV (this, *a, *b, *uv_a, *uv_b, col); }
ImDrawList_PrimQuadUV :: inline (this : *ImDrawList, a : ImVec2, b : ImVec2, c : ImVec2, d : ImVec2, uv_a : ImVec2, uv_b : ImVec2, uv_c : ImVec2, uv_d : ImVec2, col : u32) { ImDrawList__PrimQuadUV (this, *a, *b, *c, *d, *uv_a, *uv_b, *uv_c, *uv_d, col); }
//inline    void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)    { _VtxWritePtr->pos = pos; _VtxWritePtr->uv = uv; _VtxWritePtr->col = col; _VtxWritePtr++; _VtxCurrentIdx++; }
//inline    void  PrimWriteIdx(ImDrawIdx idx)                                     { *_IdxWritePtr = idx; _IdxWritePtr++; }
//inline    void  PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)         { PrimWriteIdx((ImDrawIdx)_VtxCurrentIdx); PrimWriteVtx(pos, uv, col); } // Write vertex with unique index

ImDrawList__PrimRect :: (this : *ImDrawList, const_ref_a : *ImVec2, const_ref_b : *ImVec2, col : u32) #foreign imgui "?PrimRect@ImDrawList@@QEAAXAEBUImVec2@@0I@Z";
ImDrawList__PrimRectUV :: (this : *ImDrawList, const_ref_a : *ImVec2, const_ref_b : *ImVec2, const_ref_uv_a : *ImVec2, const_ref_uv_b : *ImVec2, col : u32) #foreign imgui "?PrimRectUV@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
ImDrawList__PrimQuadUV :: (this : *ImDrawList, const_ref_a : *ImVec2, const_ref_b : *ImVec2, const_ref_c : *ImVec2, const_ref_d : *ImVec2, const_ref_uv_a : *ImVec2, const_ref_uv_b : *ImVec2, const_ref_uv_c : *ImVec2, const_ref_uv_d : *ImVec2, col : u32) #foreign imgui "?PrimQuadUV@ImDrawList@@QEAAXAEBUImVec2@@0000000I@Z";

// [Internal helpers]
//IMGUI_API void  _ResetForNewFrame();
//IMGUI_API void  _ClearFreeMemory();
//IMGUI_API void  _PopUnusedDrawCmd();
//IMGUI_API void  _OnChangedClipRect();
//IMGUI_API void  _OnChangedTextureID();
//IMGUI_API void  _OnChangedVtxOffset();

// ====================================
//     ImDrawData member functions
// ====================================

//void Clear()    { Valid = false; CmdLists = NULL; CmdListsCount = TotalVtxCount = TotalIdxCount = 0; DisplayPos = DisplaySize = FramebufferScale = ImVec2(0.f, 0.f); } // The ImDrawList are owned by ImGuiContext!
// Helper to convert all buffers from indexed to non-indexed, in case you cannot render indexed. Note: this is slow and most likely a waste of resources. Always prefer indexed rendering!
ImDrawData_DeIndexAllBuffer :: (this : *ImDrawData) #foreign imgui "?DeIndexAllBuffers@ImDrawData@@QEAAXXZ";
// Helper to scale the ClipRect field of each ImDrawCmd. Use if your final output buffer is at a different scale than Dear ImGui expects, or if there is a difference between your window resolution and framebuffer resolution.
ImDrawData_ScaleClipRects :: inline (this : *ImDrawData, fb_scale : ImVec2) { ImDrawData__ScaleClipRects (this, *fb_scale); }

ImDrawData__ScaleClipRects :: (this : *ImDrawData, const_ref_fb_scale : *ImVec2) #foreign imgui "?ScaleClipRects@ImDrawData@@QEAAXAEBUImVec2@@@Z";

// =============================================
//   ImFontGlyphRangesBuilder member functions
// =============================================

//inline void     Clear()                 { int size_in_bytes = (IM_UNICODE_CODEPOINT_MAX + 1) / 8; UsedChars.resize(size_in_bytes / (int)sizeof(ImU32)); memset(UsedChars.Data, 0, (size_t)size_in_bytes); }
//inline bool     GetBit(size_t n) const  { int off = (int)(n >> 5); ImU32 mask = 1u << (n & 31); return (UsedChars[off] & mask) != 0; }  // Get bit n in the array
//inline void     SetBit(size_t n)        { int off = (int)(n >> 5); ImU32 mask = 1u << (n & 31); UsedChars[off] |= mask; }               // Set bit n in the array
//inline void     AddChar(ImWchar c)      { SetBit(c); }                      // Add character
// Add string (each character of the UTF-8 string are added)
ImFontGlyphRangesBuilder_AddText :: (this : *ImFontGlyphRangesBuilder, text : *u8, text_end : *u8 = null) #foreign imgui "?AddText@ImFontGlyphRangesBuilder@@QEAAXPEBD0@Z";
// Add ranges, e.g. builder.AddRanges(ImFontAtlas::GetGlyphRangesDefault()) to force add all of ASCII/Latin+Ext
ImFontGlyphRangesBuilder_AddRanges :: (this : *ImFontGlyphRangesBuilder, ranges : *ImWchar) #foreign imgui "?AddRanges@ImFontGlyphRangesBuilder@@QEAAXPEBG@Z";
// Output new ranges
ImFontGlyphRangesBuilder_BuildRanges :: (this : *ImFontGlyphRangesBuilder, out_ranges : *ImVector (ImWchar)) #foreign imgui "?BuildRanges@ImFontGlyphRangesBuilder@@QEAAXPEAU?$ImVector@G@@@Z";

// =============================================
//         ImFontAtlas member functions
// =============================================

ImFontAtlas_AddFont :: (this : *ImFontAtlas, font_cfg : *ImFontConfig) -> *ImFont #foreign imgui "?AddFont@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
ImFontAtlas_AddFontDefault :: (this : *ImFontAtlas, font_cfg : *ImFontConfig = null) -> *ImFont #foreign imgui "?AddFontDefault@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
ImFontAtlas_AddFontFromFileTTF :: (this : *ImFontAtlas, filename : *u8, size_pixels : float, font_cfg : *ImFontConfig = null, glyph_ranges : *ImWchar = null) -> *ImFont #foreign imgui "?AddFontFromFileTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
// Note: Transfer ownership of 'ttf_data' to ImFontAtlas! Will be deleted after destruction of the atlas. Set font_cfg->FontDataOwnedByAtlas=false to keep ownership of your data and it won't be freed.
ImFontAtlas_AddFontFromMemoryTTF :: (this : *ImFontAtlas, font_data : *void, font_size : s32, size_pixels : float, font_cfg : *ImFontConfig = null, glyph_ranges : *ImWchar = null) -> *ImFont #foreign imgui "?AddFontFromMemoryTTF@ImFontAtlas@@QEAAPEAUImFont@@PEAXHMPEBUImFontConfig@@PEBG@Z";
// 'compressed_font_data' still owned by caller. Compress with binary_to_compressed_c.cpp.
ImFontAtlas_AddFontFromMemoryCompressedTTF :: (this : *ImFontAtlas, compressed_font_data : *void, compressed_font_size : s32, size_pixels : float, font_cfg : *ImFontConfig = null, glyph_ranges : *ImWchar = null) -> *ImFont #foreign imgui "?AddFontFromMemoryCompressedTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBXHMPEBUImFontConfig@@PEBG@Z";
// 'compressed_font_data_base85' still owned by caller. Compress with binary_to_compressed_c.cpp with -base85 parameter.
ImFontAtlas_AddFontFromMemoryCompressedBase85TTF :: (this : *ImFontAtlas, compressed_font_data_base85 : *u8, size_pixels : float, font_cfg : *ImFontConfig = null, glyph_ranges : *ImWchar = null) -> *ImFont #foreign imgui "?AddFontFromMemoryCompressedBase85TTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
// Clear input data (all ImFontConfig structures including sizes, TTF data, glyph ranges, etc.) = all the data used to build the texture and fonts.
ImFontAtlas_ClearInputData :: (this : *ImFontAtlas) #foreign imgui "?ClearInputData@ImFontAtlas@@QEAAXXZ";
// Clear output texture data (CPU side). Saves RAM once the texture has been copied to graphics memory.
ImFontAtlas_ClearTexData :: (this : *ImFontAtlas) #foreign imgui "?ClearTexData@ImFontAtlas@@QEAAXXZ";
// Clear output font data (glyphs storage, UV coordinates).
ImFontAtlas_ClearFonts :: (this : *ImFontAtlas) #foreign imgui "?ClearFonts@ImFontAtlas@@QEAAXXZ";
// Clear all input and output.
ImFontAtlas_Clear :: (this : *ImFontAtlas) #foreign imgui "?Clear@ImFontAtlas@@QEAAXXZ";

// Build atlas, retrieve pixel data.
// User is in charge of copying the pixels into graphics memory (e.g. create a texture with your engine). Then store your texture handle with SetTexID().
// The pitch is always = Width * BytesPerPixels (1 or 4)
// Building in RGBA32 format is provided for convenience and compatibility, but note that unless you manually manipulate or copy color data into
// the texture (e.g. when using the AddCustomRect*** api), then the RGB pixels emitted will always be white (~75% of memory/bandwidth waste.
// Build pixels data. This is called automatically for you by the GetTexData*** functions.
ImFontAtlas_Build :: (this : *ImFontAtlas) -> bool #foreign imgui "?Build@ImFontAtlas@@QEAA_NXZ";

// 1 byte per-pixel
ImFontAtlas_GetTexDataAsAlpha8 :: (this : *ImFontAtlas, out_pixels : **u8, out_width : *s32, out_height : *s32, out_bytes_per_pixel : *s32 = null) #foreign imgui "?GetTexDataAsAlpha8@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";
// 4 bytes-per-pixel
ImFontAtlas_GetTexDataAsRGBA32 :: (this : *ImFontAtlas, out_pixels : **u8, out_width : *s32, out_height : *s32, out_bytes_per_pixel : *s32 = null) #foreign imgui "?GetTexDataAsRGBA32@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";
//bool                        IsBuilt() const             { return Fonts.Size > 0 && (TexPixelsAlpha8 != NULL || TexPixelsRGBA32 != NULL); }
//void                        SetTexID(ImTextureID id)    { TexID = id; }

//-------------------------------------------
// Glyph Ranges
//-------------------------------------------

// Helpers to retrieve list of common Unicode ranges (2 value per range, values are inclusive, zero-terminated list)
// NB: Make sure that your string are UTF-8 and NOT in your local code page. In C++11, you can create UTF-8 string literal using the u8"Hello world" syntax. See FAQ for details.
// NB: Consider using ImFontGlyphRangesBuilder to build glyph ranges from textual data.
// Basic Latin, Extended Latin
ImFontAtlas_GetGlyphRangesDefault :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesDefault@ImFontAtlas@@QEAAPEBGXZ";
// Default + Korean characters
ImFontAtlas_GetGlyphRangesKorean :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesKorean@ImFontAtlas@@QEAAPEBGXZ";
// Default + Hiragana, Katakana, Half-Width, Selection of 1946 Ideographs
ImFontAtlas_GetGlyphRangesJapanese :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesJapanese@ImFontAtlas@@QEAAPEBGXZ";
// Default + Half-Width + Japanese Hiragana/Katakana + full set of about 21000 CJK Unified Ideographs
ImFontAtlas_GetGlyphRangesChineseFull :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesChineseFull@ImFontAtlas@@QEAAPEBGXZ";
// Default + Half-Width + Japanese Hiragana/Katakana + set of 2500 CJK Unified Ideographs for common simplified Chinese
ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesChineseSimplifiedCommon@ImFontAtlas@@QEAAPEBGXZ";
// Default + about 400 Cyrillic characters
ImFontAtlas_GetGlyphRangesCyrillic :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesCyrillic@ImFontAtlas@@QEAAPEBGXZ";
// Default + Thai characters
ImFontAtlas_GetGlyphRangesThai :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesThai@ImFontAtlas@@QEAAPEBGXZ";
// Default + Vietnamese characters
ImFontAtlas_GetGlyphRangesVietnamese :: (this : *ImFontAtlas) -> *ImWchar #foreign imgui "?GetGlyphRangesVietnamese@ImFontAtlas@@QEAAPEBGXZ";

//-------------------------------------------
// [BETA] Custom Rectangles/Glyphs API
//-------------------------------------------

// You can request arbitrary rectangles to be packed into the atlas, for your own purposes.
// After calling Build(), you can query the rectangle position and render your pixels.
// You can also request your rectangles to be mapped as font glyph (given a font + Unicode point),
// so you can render e.g. custom colorful icons and use them as regular glyphs.
// Read docs/FONTS.md for more details about using colorful icons.
// Note: this API may be redesigned later in order to support multi-monitor varying DPI settings.
ImFontAtlas_AddCustomRectRegular :: (this : *ImFontAtlas, width : s32, height : s32) -> s32 #foreign imgui "?AddCustomRectRegular@ImFontAtlas@@QEAAHHH@Z";
ImFontAtlas_AddCustomRectFontGlyph :: inline (this : *ImFontAtlas, width : s32, height : s32, advance_x : float, offset : ImVec2 = .{ 0, 0 }) -> s32 { return ImFontAtlas__AddCustomRectFontGlyph (this, width, height, advance_x, *offset); }
//ImFontAtlasCustomRect*      GetCustomRectByIndex(int index) { IM_ASSERT(index >= 0); return &CustomRects[index]; }

ImFontAtlas__AddCustomRectFontGlyph :: (this : *ImFontAtlas, width : s32, height : s32, advance_x : float, const_ref_offset : *ImVec2) -> s32 #foreign imgui "?AddCustomRectFontGlyph@ImFontAtlas@@QEAAHPEAUImFont@@GHHMAEBUImVec2@@@Z";

// [Internal]
//IMGUI_API void              CalcCustomRectUV(const ImFontAtlasCustomRect* rect, ImVec2* out_uv_min, ImVec2* out_uv_max) const;
//IMGUI_API bool              GetMouseCursorTexData(ImGuiMouseCursor cursor, ImVec2* out_offset, ImVec2* out_size, ImVec2 out_uv_border[2], ImVec2 out_uv_fill[2]);

// =============================================
//           ImFont member functions
// =============================================

ImFont_FindGlyph :: (this : *ImFontGlyph, c : ImWchar) -> *ImFontGlyph #foreign imgui "?FindGlyph@ImFont@@QEBAPEBUImFontGlyph@@G@Z";
ImFont_FindGlyphNoFallback :: (this : *ImFontGlyph, c : ImWchar) -> *ImFontGlyph #foreign imgui "?FindGlyphNoFallback@ImFont@@QEBAPEBUImFontGlyph@@G@Z";
//float                       GetCharAdvance(ImWchar c) const     { return ((int)c < IndexAdvanceX.Size) ? IndexAdvanceX[(int)c] : FallbackAdvanceX; }
//bool                        IsLoaded() const                    { return ContainerAtlas != NULL; }
//const char*                 GetDebugName() const                { return ConfigData ? ConfigData->Name : "<unknown>"; }

// 'max_width' stops rendering after a certain width (could be turned into a 2d size). FLT_MAX to disable.
// 'wrap_width' enable automatic word-wrapping across multiple lines to fit into given width. 0.0f to disable.
// utf8
ImFont_CalcTextSizeA :: (this : *ImFont, size : float, max_width : float, wrap_width : float, text_begin : *u8, text_end : *u8 = null, remaining : **u8 = null) -> ImVec2 #foreign imgui "?CalcTextSizeA@ImFont@@QEBA?AUImVec2@@MMMPEBD0PEAPEBD@Z";
ImFont_CalcWordWrapPositionA :: (this : *ImFont, scale : float, text : *u8, text_end : *u8, wrap_width : float) -> *u8 #foreign imgui "?CalcTextSizeA@ImFont@@QEBA?AUImVec2@@MMMPEBD0PEAPEBD@Z";
ImFont_RenderChar :: (this : *ImFont, draw_list : *ImDrawList, size : float, pos : ImVec2, col : u32, c : ImWchar) #foreign imgui "?RenderChar@ImFont@@QEBAXPEAUImDrawList@@MUImVec2@@IG@Z";
ImFont_RenderText :: (this : *ImFont, draw_list : *ImDrawList, size : float, pos : ImVec2, col : u32, clip_rect : ImVec2, text_begin : *u8, text_end : *u8, wrap_width : float = 0, cpu_fine_clip : bool = false) { ImFont__RenderText (this, draw_list, size, pos, col, *clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip); }

ImFont__RenderText :: (this : *ImFont, draw_list : *ImDrawList, size : float, pos : ImVec2, col : u32, const_ref_clip_rect : *ImVec2, text_begin : *u8, text_end : *u8, wrap_width : float, cpu_fine_clip : bool) #foreign imgui "?RenderText@ImFont@@QEBAXPEAUImDrawList@@MUImVec2@@IAEBUImVec4@@PEBD3M_N@Z";

// [Internal] Don't use!
//IMGUI_API void              BuildLookupTable();
//IMGUI_API void              ClearOutputData();
//IMGUI_API void              GrowIndex(int new_size);
//IMGUI_API void              AddGlyph(const ImFontConfig* src_cfg, ImWchar c, float x0, float y0, float x1, float y1, float u0, float v0, float u1, float v1, float advance_x);
//IMGUI_API void              AddRemapChar(ImWchar dst, ImWchar src, bool overwrite_dst = true); // Makes 'dst' character/glyph points to 'src' character/glyph. Currently needs to be called AFTER fonts have been built.
//IMGUI_API void              SetGlyphVisible(ImWchar c, bool visible);
//IMGUI_API void              SetFallbackChar(ImWchar c);
//IMGUI_API bool              IsGlyphRangeUnused(unsigned int c_begin, unsigned int c_last);

#scope_file

#if STATIC_LINKING
{
	#if IMPORT_DEBUG_SYMBOLS  imgui :: #foreign_library, no_dll "win_debug/ImGui";
	else                      imgui :: #foreign_library, no_dll "win/ImGui";
}
else
{
	#if IMPORT_DEBUG_SYMBOLS  imgui :: #foreign_library "win_debug/ImGui";
	else                      imgui :: #foreign_library "win/ImGui";
}
