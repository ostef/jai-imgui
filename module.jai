#module_parameters (IMPORT_DEBUG_SYMBOLS := true, STATIC_LINKING := true);

#scope_module

#import "Basic";
#import "Math";

#scope_export

#if OS == .WINDOWS  #load "windows.jai";

IMGUI_VERSION     :: "1.79";
IMGUI_VERSION_NUM :: 17900;

ImGui_CheckVersion :: () #expand
{
	assert (ImGui_DebugCheckVersionAndDataLayout (IMGUI_VERSION, size_of (ImGuiIO), size_of (ImGuiStyle), size_of (ImVec2), size_of (ImVec4), size_of (ImDrawVert), size_of (ImDrawIdx)), "ImGui_CheckVersion failed.");
}

ImTextureID :: *void;
ImGuiID     :: u32;
ImGuiInputTextCallback :: #type (data : *ImGuiInputTextCallbackData) -> s32 #c_call;
ImGuiSizeCallback      :: #type (data : *ImGuiSizeCallbackData) -> void #c_call;
ImVec2 :: Vector2;
ImVec4 :: Vector4;
ImWchar :: u16;

ImGuiContext :: struct {};
ImGuiStorage :: struct {};

IM_COL32_WHITE       :: 0xffffffff;
IM_COL32_BLACK       :: 0x000000ff;
IM_COL32_BLACK_TRANS :: 0x00000000;

//-----------------------------------------------------------------------------
// Flags & Enumerations
//-----------------------------------------------------------------------------

ImGuiWindowFlags :: enum_flags s32
{
	None                   :: 0;
	NoTitleBar             :: 1 << 0;   // Disable title-bar
	NoResize               :: 1 << 1;   // Disable user resizing with the lower-right grip
	NoMove                 :: 1 << 2;   // Disable user moving the window
	NoScrollbar            :: 1 << 3;   // Disable scrollbars (window can still scroll with mouse or programmatically)
	NoScrollWithMouse      :: 1 << 4;   // Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
	NoCollapse             :: 1 << 5;   // Disable user collapsing window by double-clicking on it
	AlwaysAutoResize       :: 1 << 6;   // Resize every window to its content every frame
	NoBackground           :: 1 << 7;   // Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
	NoSavedSettings        :: 1 << 8;   // Never load/save settings in .ini file
	NoMouseInputs          :: 1 << 9;   // Disable catching mouse, hovering test with pass through.
	MenuBar                :: 1 << 10;  // Has a menu-bar
	HorizontalScrollbar    :: 1 << 11;  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
	NoFocusOnAppearing        :: 1 << 12;  // Disable taking focus when transitioning from hidden to visible state
	NoBringToFrontOnFocus     :: 1 << 13;  // Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
	AlwaysVerticalScrollbar   :: 1 << 14;  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
	AlwaysHorizontalScrollbar :: 1<< 15;  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
	AlwaysUseWindowPadding :: 1 << 16;  // Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
	NoNavInputs            :: 1 << 18;  // No gamepad/keyboard navigation within the window
	NoNavFocus             :: 1 << 19;  // No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
	UnsavedDocument        :: 1 << 20;  // Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
	NoNav                  :: ImGuiWindowFlags.NoNavInputs | .NoNavFocus;
	NoDecoration           :: ImGuiWindowFlags.NoTitleBar | .NoResize | .NoScrollbar | .NoCollapse;
	NoInputs               :: ImGuiWindowFlags.NoMouseInputs | .NoNavInputs | .NoNavFocus;

	// [Internal]
	NavFlattened           :: 1 << 23;  // [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
	ChildWindow            :: 1 << 24;  // Don't use! For internal use by BeginChild()
	Tooltip                :: 1 << 25;  // Don't use! For internal use by BeginTooltip()
	Popup                  :: 1 << 26;  // Don't use! For internal use by BeginPopup()
	Modal                  :: 1 << 27;  // Don't use! For internal use by BeginPopupModal()
	ChildMenu              :: 1 << 28;  // Don't use! For internal use by BeginMenu()
}

ImGuiInputTextFlags :: enum_flags s32
{
	None                :: 0;
	CharsDecimal        :: 1 << 0;   // Allow 0123456789.+-*/
	CharsHexadecimal    :: 1 << 1;   // Allow 0123456789ABCDEFabcdef
	CharsUppercase      :: 1 << 2;   // Turn a..z into A..Z
	CharsNoBlank        :: 1 << 3;   // Filter out spaces, tabs
	AutoSelectAll       :: 1 << 4;   // Select entire text when first taking mouse focus
	EnterReturnsTrue    :: 1 << 5;   // Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
	CallbackCompletion  :: 1 << 6;   // Callback on pressing TAB (for completion handling)
	CallbackHistory     :: 1 << 7;   // Callback on pressing Up/Down arrows (for history handling)
	CallbackAlways      :: 1 << 8;   // Callback on each iteration. User code may query cursor position, modify text buffer.
	CallbackCharFilter  :: 1 << 9;   // Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
	AllowTabInput       :: 1 << 10;  // Pressing TAB input a '\t' character into the text field
	CtrlEnterForNewLine :: 1 << 11;  // In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
	NoHorizontalScroll  :: 1 << 12;  // Disable following the cursor horizontally
	AlwaysInsertMode    :: 1 << 13;  // Insert mode
	ReadOnly            :: 1 << 14;  // Read-only mode
	Password            :: 1 << 15;  // Password mode, display all characters as '*'
	NoUndoRedo          :: 1 << 16;  // Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
	CharsScientific     :: 1 << 17;  // Allow 0123456789.+-*/eE (Scientific notation input)
	CallbackResize      :: 1 << 18;  // Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
	CallbackEdit        :: 1 << 19;  // Callback on any edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
	// [Internal]
	Multiline           :: 1 << 20;  // For internal use by InputTextMultiline()
	NoMarkEdited        :: 1 << 21;  // For internal use by functions using InputText() before reformatting data
}

ImGuiTreeNodeFlags :: enum_flags s32
{
	None                 :: 0;
	Selected             :: 1 << 0;   // Draw as selected
	Framed               :: 1 << 1;   // Full colored frame (e.g. for CollapsingHeader)
	AllowItemOverlap     :: 1 << 2;   // Hit testing to allow subsequent widgets to overlap this one
	NoTreePushOnOpen     :: 1 << 3;   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
	NoAutoOpenOnLog      :: 1 << 4;   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
	DefaultOpen          :: 1 << 5;   // Default node to be open
	OpenOnDoubleClick    :: 1 << 6;   // Need double-click to open node
	OpenOnArrow          :: 1 << 7;   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
	Leaf                 :: 1 << 8;   // No collapsing, no arrow (use as a convenience for leaf nodes).
	Bullet               :: 1 << 9;   // Display a bullet instead of arrow
	FramePadding         :: 1 << 10;  // Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
	SpanAvailWidth       :: 1 << 11;  // Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
	SpanFullWidth        :: 1 << 12;  // Extend hit box to the left-most and right-most edges (bypass the indented area).
	NavLeftJumpsBackHere :: 1 << 13;  // (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
	//ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 14,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
	CollapsingHeader     :: ImGuiTreeNodeFlags.Framed | .NoTreePushOnOpen | .NoAutoOpenOnLog;
}

// Flags for OpenPopup*(), BeginPopupContext*(), IsPopupOpen() functions.
// - To be backward compatible with older API which took an 'int mouse_button = 1' argument, we need to treat
//   small flags values as a mouse button index, so we encode the mouse button in the first few bits of the flags.
//   It is therefore guaranteed to be legal to pass a mouse button index in ImGuiPopupFlags.
// - For the same reason, we exceptionally default the ImGuiPopupFlags argument of BeginPopupContextXXX functions to 1 instead of 0.
//   IMPORTANT: because the default parameter is 1 (==ImGuiPopupFlags_MouseButtonRight), if you rely on the default parameter
//   and want to another another flag, you need to pass in the ImGuiPopupFlags_MouseButtonRight flag.
// - Multiple buttons currently cannot be combined/or-ed in those functions (we could allow it later).
ImGuiPopupFlags :: enum_flags s32
{
	None                    :: 0;
	MouseButtonLeft         :: 0;        // For BeginPopupContext*(): open on Left Mouse release. Guaranteed to always be == 0 (same as ImGuiMouseButton_Left)
	MouseButtonRight        :: 1;        // For BeginPopupContext*(): open on Right Mouse release. Guaranteed to always be == 1 (same as ImGuiMouseButton_Right)
	MouseButtonMiddle       :: 2;        // For BeginPopupContext*(): open on Middle Mouse release. Guaranteed to always be == 2 (same as ImGuiMouseButton_Middle)
	MouseButtonMask_        :: 0x1f;
	MouseButtonDefault_     :: 1;
	NoOpenOverExistingPopup :: 1 << 5;   // For OpenPopup*(), BeginPopupContext*(): don't open if there's already a popup at the same level of the popup stack
	NoOpenOverItems         :: 1 << 6;   // For BeginPopupContextWindow(): don't return true when hovering items, only when hovering empty space
	AnyPopupId              :: 1 << 7;   // For IsPopupOpen(): ignore the ImGuiID parameter and test for any popup.
	AnyPopupLevel           :: 1 << 8;   // For IsPopupOpen(): search/test at any level of the popup stack (default test in the current level)
	AnyPopup                :: ImGuiPopupFlags.AnyPopupId | .AnyPopupLevel;
}

ImGuiSelectableFlags :: enum_flags s32
{
	None               :: 0;
	DontClosePopups    :: 1 << 0;   // Clicking this don't close parent popup window
	SpanAllColumns     :: 1 << 1;   // Selectable frame can span all columns (text will still fit in current column)
	AllowDoubleClick   :: 1 << 2;   // Generate press events on double clicks too
	Disabled           :: 1 << 3;   // Cannot be selected, display grayed out text
	AllowItemOverlap   :: 1 << 4;   // (WIP) Hit testing to allow subsequent widgets to overlap this one
}

ImGuiComboFlags :: enum_flags s32
{
	None                    :: 0;
	PopupAlignLeft          :: 1 << 0;   // Align the popup toward the left by default
	HeightSmall             :: 1 << 1;   // Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
	HeightRegular           :: 1 << 2;   // Max ~8 items visible (default)
	HeightLarge             :: 1 << 3;   // Max ~20 items visible
	HeightLargest           :: 1 << 4;   // As many fitting items as possible
	NoArrowButton           :: 1 << 5;   // Display on the preview box without the square arrow button
	NoPreview               :: 1 << 6;   // Display only a square arrow button
	HeightMask_             :: ImGuiComboFlags.HeightSmall | .HeightRegular | .HeightLarge | .HeightLargest;
}

ImGuiTabBarFlags :: enum_flags s32
{
	None                           :: 0;
	Reorderable                    :: 1 << 0;   // Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
	AutoSelectNewTabs              :: 1 << 1;   // Automatically select new tabs when they appear
	TabListPopupButton             :: 1 << 2;   // Disable buttons to open the tab list popup
	NoCloseWithMiddleMouseButton   :: 1 << 3;   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
	NoTabListScrollingButtons      :: 1 << 4;   // Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
	NoTooltip                      :: 1 << 5;   // Disable tooltips when hovering a tab
	FittingPolicyResizeDown        :: 1 << 6;   // Resize tabs when they don't fit
	FittingPolicyScroll            :: 1 << 7;   // Add scroll buttons when tabs don't fit
	FittingPolicyMask_             :: ImGuiTabBarFlags.FittingPolicyResizeDown | .FittingPolicyScroll;
	FittingPolicyDefault_          :: ImGuiTabBarFlags.FittingPolicyResizeDown;
}

ImGuiTabItemFlags :: enum_flags s32
{
	None                          :: 0;
	UnsavedDocument               :: 1 << 0;   // Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. Also: tab is selected on closure and closure is deferred by one frame to allow code to undo it without flicker.
	SetSelected                   :: 1 << 1;   // Trigger flag to programmatically make the tab selected when calling BeginTabItem()
	NoCloseWithMiddleMouseButton  :: 1 << 2;   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
	NoPushId                      :: 1 << 3;   // Don't call PushID(tab->ID)/PopID() on BeginTabItem()/EndTabItem()
	NoTooltip                     :: 1 << 4;   // Disable tooltip for the given tab
	NoReorder                     :: 1 << 5;   // Disable reordering this tab or having another tab cross over this tab
	Leading                       :: 1 << 6;   // Enforce the tab position to the left of the tab bar (after the tab list popup button)
	Trailing                      :: 1 << 7;   // Enforce the tab position to the right of the tab bar (before the scrolling buttons)
}

ImGuiFocusedFlags :: enum_flags s32
{
	None                          :: 0;
	ChildWindows                  :: 1 << 0;   // IsWindowFocused(): Return true if any children of the window is focused
	RootWindow                    :: 1 << 1;   // IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
	AnyWindow                     :: 1 << 2;   // IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
	RootAndChildWindows           :: ImGuiFocusedFlags.RootWindow | .ChildWindows;
}

// Note: if you are trying to check whether your mouse should be dispatched to Dear ImGui or to your app, you should use 'io.WantCaptureMouse' instead! Please read the FAQ!
// Note: windows with the ImGuiWindowFlags_NoInputs flag are ignored by IsWindowHovered() calls.
ImGuiHoveredFlags :: enum_flags s32
{
	None                          :: 0;        // Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
	ChildWindows                  :: 1 << 0;   // IsWindowHovered() only: Return true if any children of the window is hovered
	RootWindow                    :: 1 << 1;   // IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
	AnyWindow                     :: 1 << 2;   // IsWindowHovered() only: Return true if any window is hovered
	AllowWhenBlockedByPopup       :: 1 << 3;   // Return true even if a popup window is normally blocking access to this item/window
	//AllowWhenBlockedByModal     :: 1 << 4;   // Return true even if a modal popup window is normally blocking access to this item/window. FIXME-TODO: Unavailable yet.
	AllowWhenBlockedByActiveItem  :: 1 << 5;   // Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
	AllowWhenOverlapped           :: 1 << 6;   // Return true even if the position is obstructed or overlapped by another window
	AllowWhenDisabled             :: 1 << 7;   // Return true even if the item is disabled
	RectOnly                      :: ImGuiHoveredFlags.AllowWhenBlockedByPopup | .AllowWhenBlockedByActiveItem | .AllowWhenOverlapped;
	RootAndChildWindows           :: ImGuiHoveredFlags.RootWindow | .ChildWindows;
}

ImGuiDragDropFlags :: enum_flags s32
{
	None                         :: 0;
	// BeginDragDropSource() flags
	SourceNoPreviewTooltip       :: 1 << 0;   // By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
	SourceNoDisableHover         :: 1 << 1;   // By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
	SourceNoHoldToOpenOthers     :: 1 << 2;   // Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
	SourceAllowNullID            :: 1 << 3;   // Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
	SourceExtern                 :: 1 << 4;   // External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
	SourceAutoExpirePayload      :: 1 << 5;   // Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
	// AcceptDragDropPayload() flags
	AcceptBeforeDelivery         :: 1 << 10;  // AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
	AcceptNoDrawDefaultRect      :: 1 << 11;  // Do not draw the default highlight rectangle when hovering over target.
	AcceptNoPreviewTooltip       :: 1 << 12;  // Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
	AcceptPeekOnly               :: ImGuiDragDropFlags.AcceptBeforeDelivery | .AcceptNoDrawDefaultRect;  // For peeking ahead and inspecting the payload before delivery.
}

ImGuiDataType :: enum s32
{
	S8;       // signed char / char (with sensible compilers)
	U8;       // unsigned char
	S16;      // short
	U16;      // unsigned short
	S32;      // int
	U32;      // unsigned int
	S64;      // long long / __int64
	U64;      // unsigned long long / unsigned __int64
	Float;    // float
	Double;   // double
	COUNT;
}

// A cardinal direction
ImGuiDir :: enum s32
{
	None    :: -1;
	Left    :: 0;
	Right   :: 1;
	Up      :: 2;
	Down    :: 3;
	COUNT;
}

ImGuiKey :: enum s32
{
	Tab;
	LeftArrow;
	RightArrow;
	UpArrow;
	DownArrow;
	PageUp;
	PageDown;
	Home;
	End;
	Insert;
	Delete;
	Backspace;
	Space;
	Enter;
	Escape;
	KeyPadEnter;
	A;                 // for text edit CTRL+A: select all
	C;                 // for text edit CTRL+C: copy
	V;                 // for text edit CTRL+V: paste
	X;                 // for text edit CTRL+X: cut
	Y;                 // for text edit CTRL+Y: redo
	Z;                 // for text edit CTRL+Z: undo
	COUNT;
}

ImGuiKeyModFlags :: enum_flags s32
{
	None       :: 0;
	Ctrl       :: 1 << 0;;
	Shift      :: 1 << 1;;
	Alt        :: 1 << 2;;
	Super      :: 1 << 3;
}

// Gamepad/Keyboard navigation
// Keyboard: Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard to enable. NewFrame() will automatically fill io.NavInputs[] based on your io.KeysDown[] + io.KeyMap[] arrays.
// Gamepad:  Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad to enable. Back-end: set ImGuiBackendFlags_HasGamepad and fill the io.NavInputs[] fields before calling NewFrame(). Note that io.NavInputs[] is cleared by EndFrame().
// Read instructions in imgui.cpp for more details. Download PNG/PSD at http://goo.gl/9LgVZW.
ImGuiNavInput :: enum s32
{
	// Gamepad Mapping
	Activate;      // activate / open / toggle / tweak value       // e.g. Cross  (PS4), A (Xbox), A (Switch), Space (Keyboard)
	Cancel;        // cancel / close / exit                        // e.g. Circle (PS4), B (Xbox), B (Switch), Escape (Keyboard)
	Input;         // text input / on-screen keyboard              // e.g. Triang.(PS4), Y (Xbox), X (Switch), Return (Keyboard)
	Menu;          // tap: toggle menu / hold: focus, move, resize // e.g. Square (PS4), X (Xbox), Y (Switch), Alt (Keyboard)
	DpadLeft;      // move / tweak / resize window (w/ PadMenu)    // e.g. D-pad Left/Right/Up/Down (Gamepads), Arrow keys (Keyboard)
	DpadRight;     //
	DpadUp;        //
	DpadDown;      //
	LStickLeft;    // scroll / move window (w/ PadMenu)            // e.g. Left Analog Stick Left/Right/Up/Down
	LStickRight;   //
	LStickUp;      //
	LStickDown;    //
	FocusPrev;     // next window (w/ PadMenu)                     // e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
	FocusNext;     // prev window (w/ PadMenu)                     // e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
	TweakSlow;     // slower tweaks                                // e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
	TweakFast;     // faster tweaks                                // e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)

	// [Internal] Don't use directly! This is used internally to differentiate keyboard from gamepad inputs for behaviors that require to differentiate them.
	// Keyboard behavior that have no corresponding gamepad mapping (e.g. CTRL+TAB) will be directly reading from io.KeysDown[] instead of io.NavInputs[].
	KeyMenu_;      // toggle menu                                  // = io.KeyAlt
	KeyLeft_;      // move left                                    // = Arrow keys
	KeyRight_;     // move right
	KeyUp_;        // move up
	KeyDown_;      // move down
	COUNT;
	InternalStart_ :: ImGuiNavInput.KeyMenu_;
}

ImGuiConfigFlags :: enum_flags s32
{
	None                   :: 0;
	NavEnableKeyboard      :: 1 << 0;   // Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeysDown[].
	NavEnableGamepad       :: 1 << 1;   // Master gamepad navigation enable flag. This is mostly to instruct your imgui back-end to fill io.NavInputs[]. Back-end also needs to set ImGuiBackendFlags_HasGamepad.
	NavEnableSetMousePos   :: 1 << 2;   // Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your binding, otherwise ImGui will react as if the mouse is jumping around back and forth.
	NavNoCaptureKeyboard   :: 1 << 3;   // Instruct navigation to not set the io.WantCaptureKeyboard flag when io.NavActive is set.
	NoMouse                :: 1 << 4;   // Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the back-end.
	NoMouseCursorChange    :: 1 << 5;   // Instruct back-end to not alter mouse cursor shape and visibility. Use if the back-end cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.

	// User storage (to allow your back-end/engine to communicate to code that may be shared between multiple projects. Those flags are not used by core Dear ImGui)
	IsSRGB                 :: 1 << 20;  // Application is SRGB-aware.
	IsTouchScreen          :: 1 << 21;  // Application is using a touch screen instead of a mouse.
}

ImGuiBackendFlags :: enum_flags s32
{
	None                  :: 0;
	HasGamepad            :: 1 << 0;   // Back-end Platform supports gamepad and currently has one connected.
	HasMouseCursors       :: 1 << 1;   // Back-end Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
	HasSetMousePos        :: 1 << 2;   // Back-end Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
	RendererHasVtxOffset  :: 1 << 3;   // Back-end Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.
}

ImGuiCol :: enum s32
{
	Text;
	TextDisabled;
	WindowBg;              // Background of normal windows
	ChildBg;               // Background of child windows
	PopupBg;               // Background of popups, menus, tooltips windows
	Border;
	BorderShadow;
	FrameBg;               // Background of checkbox, radio button, plot, slider, text input
	FrameBgHovered;
	FrameBgActive;
	TitleBg;
	TitleBgActive;
	TitleBgCollapsed;
	MenuBarBg;
	ScrollbarBg;
	ScrollbarGrab;
	ScrollbarGrabHovered;
	ScrollbarGrabActive;
	CheckMark;
	SliderGrab;
	SliderGrabActive;
	Button;
	ButtonHovered;
	ButtonActive;
	Header;                // Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
	HeaderHovered;
	HeaderActive;
	Separator;
	SeparatorHovered;
	SeparatorActive;
	ResizeGrip;
	ResizeGripHovered;
	ResizeGripActive;
	Tab;
	TabHovered;
	TabActive;
	TabUnfocused;
	TabUnfocusedActive;
	PlotLines;
	PlotLinesHovered;
	PlotHistogram;
	PlotHistogramHovered;
	TextSelectedBg;
	DragDropTarget;
	NavHighlight;          // Gamepad/keyboard: current highlighted item
	NavWindowingHighlight; // Highlight window when using CTRL+TAB
	NavWindowingDimBg;     // Darken/colorize entire screen behind the CTRL+TAB window list, when active
	ModalWindowDimBg;      // Darken/colorize entire screen behind a modal window, when one is active
	COUNT;
}

// - The enum only refers to fields of ImGuiStyle which makes sense to be pushed/popped inside UI code.
//   During initialization or between frames, feel free to just poke into ImGuiStyle directly.
// - Tip: Use your programming IDE navigation facilities on the names in the _second column_ below to find the actual members and their description.
//   In Visual Studio IDE: CTRL+comma ("Edit.NavigateTo") can follow symbols in comments, whereas CTRL+F12 ("Edit.GoToImplementation") cannot.
//   With Visual Assist installed: ALT+G ("VAssistX.GoToImplementation") can also follow symbols in comments.
// - When changing this enum, you need to update the associated internal table GStyleVarInfo[] accordingly. This is where we link enum values to members offset/type.
ImGuiStyleVar :: enum s32
{
	// Enum name --------------------- // Member in ImGuiStyle structure (see ImGuiStyle for descriptions)
	Alpha;               // float     Alpha
	WindowPadding;       // ImVec2    WindowPadding
	WindowRounding;      // float     WindowRounding
	WindowBorderSize;    // float     WindowBorderSize
	WindowMinSize;       // ImVec2    WindowMinSize
	WindowTitleAlign;    // ImVec2    WindowTitleAlign
	ChildRounding;       // float     ChildRounding
	ChildBorderSize;     // float     ChildBorderSize
	PopupRounding;       // float     PopupRounding
	PopupBorderSize;     // float     PopupBorderSize
	FramePadding;        // ImVec2    FramePadding
	FrameRounding;       // float     FrameRounding
	FrameBorderSize;     // float     FrameBorderSize
	ItemSpacing;         // ImVec2    ItemSpacing
	ItemInnerSpacing;    // ImVec2    ItemInnerSpacing
	IndentSpacing;       // float     IndentSpacing
	ScrollbarSize;       // float     ScrollbarSize
	ScrollbarRounding;   // float     ScrollbarRounding
	GrabMinSize;         // float     GrabMinSize
	GrabRounding;        // float     GrabRounding
	TabRounding;         // float     TabRounding
	ButtonTextAlign;     // ImVec2    ButtonTextAlign
	SelectableTextAlign; // ImVec2    SelectableTextAlign
	COUNT;
}

ImGuiButtonFlags :: enum_flags s32
{
	None                   :: 0;
	MouseButtonLeft        :: 1 << 0;   // React on left mouse button (default)
	MouseButtonRight       :: 1 << 1;   // React on right mouse button
	MouseButtonMiddle      :: 1 << 2;   // React on center mouse button

	// [Internal]
	MouseButtonMask_       :: ImGuiButtonFlags.MouseButtonLeft | .MouseButtonRight | .MouseButtonMiddle;
	MouseButtonDefault_    :: ImGuiButtonFlags.MouseButtonLeft;
}

ImGuiColorEditFlags :: enum_flags s32
{
	None            :: 0;
	NoAlpha         :: 1 << 1;   //              // ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
	NoPicker        :: 1 << 2;   //              // ColorEdit: disable picker when clicking on colored square.
	NoOptions       :: 1 << 3;   //              // ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
	NoSmallPreview  :: 1 << 4;   //              // ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
	NoInputs        :: 1 << 5;   //              // ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
	NoTooltip       :: 1 << 6;   //              // ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
	NoLabel         :: 1 << 7;   //              // ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
	NoSidePreview   :: 1 << 8;   //              // ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.
	NoDragDrop      :: 1 << 9;   //              // ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.
	NoBorder        :: 1 << 10;  //              // ColorButton: disable border (which is enforced by default)

	// User Options (right-click on widget to change some of them).
	AlphaBar         :: 1 << 16;  //              // ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
	AlphaPreview     :: 1 << 17;  //              // ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
	AlphaPreviewHalf :: 1 << 18;  //              // ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
	HDR              :: 1 << 19;  //              // (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
	DisplayRGB       :: 1 << 20;  // [Display]    // ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
	DisplayHSV       :: 1 << 21;  // [Display]    // "
	DisplayHex       :: 1 << 22;  // [Display]    // "
	Uint8            :: 1 << 23;  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
	Float            :: 1 << 24;  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
	PickerHueBar     :: 1 << 25;  // [Picker]     // ColorPicker: bar for Hue, rectangle for Sat/Value.
	PickerHueWheel   :: 1 << 26;  // [Picker]     // ColorPicker: wheel for Hue, triangle for Sat/Value.
	InputRGB         :: 1 << 27;  // [Input]      // ColorEdit, ColorPicker: input and output data in RGB format.
	InputHSV         :: 1 << 28;  // [Input]      // ColorEdit, ColorPicker: input and output data in HSV format.

	// Defaults Options. You can set application defaults using SetColorEditOptions(). The intent is that you probably don't want to
	// override them in most of your calls. Let the user choose via the option menu and/or call SetColorEditOptions() once during startup.
	_OptionsDefault :: ImGuiColorEditFlags.Uint8 | .DisplayRGB | .InputRGB | .PickerHueBar;

	// [Internal] Masks
	_DisplayMask    :: ImGuiColorEditFlags.DisplayRGB | .DisplayHSV | .DisplayHex;
	_DataTypeMask   :: ImGuiColorEditFlags.Uint8 | .Float;
	_PickerMask     :: ImGuiColorEditFlags.PickerHueWheel | .PickerHueBar;
	_InputMask      :: ImGuiColorEditFlags.InputRGB | .InputHSV;
}

ImGuiSliderFlags :: enum_flags s32
{
	None                   :: 0;
	AlwaysClamp            :: 1 << 4;       // Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
	Logarithmic            :: 1 << 5;       // Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
	NoRoundToFormat        :: 1 << 6;       // Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
	NoInput                :: 1 << 7;       // Disable CTRL+Click or Enter key allowing to input text directly into the widget
	InvalidMask_           :: 0x7000000f;    // [Internal] We treat using those bits as being potentially a 'float power' argument from the previous API that has got miscast to this enum, and will trigger an assert if needed.
}

ImGuiMouseButton :: enum s32
{
	Left   :: 0;
	Right  :: 1;
	Middle :: 2;
	COUNT  :: 5;
}


// Enumeration for GetMouseCursor()
// User code may request binding to display given cursor by calling SetMouseCursor(), which is why we have some cursors that are marked unused here
ImGuiMouseCursor :: enum s32
{
	None :: -1;
	Arrow :: 0;
	TextInput;         // When hovering over InputText, etc.
	ResizeAll;         // (Unused by Dear ImGui functions)
	ResizeNS;          // When hovering over an horizontal border
	ResizeEW;          // When hovering over a vertical border or a column
	ResizeNESW;        // When hovering over the bottom-left corner of a window
	ResizeNWSE;        // When hovering over the bottom-right corner of a window
	Hand;              // (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
	NotAllowed;        // When hovering something with disallowed interaction. Usually a crossed circle.
	COUNT;
}

// Important: Treat as a regular enum! Do NOT combine multiple values using binary operators! All the functions above treat 0 as a shortcut to ImGuiCond_Always.
ImGuiCond :: enum s32
{
	None          :: 0;        // No condition (always set the variable), same as _Always
	Always        :: 1 << 0;   // No condition (always set the variable)
	Once          :: 1 << 1;   // Set the variable once per runtime session (only the first call will succeed)
	FirstUseEver  :: 1 << 2;   // Set the variable if the object/window has no persistently saved data (no entry in .ini file)
	Appearing     :: 1 << 3;   // Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
};

ImVector :: struct (T : Type)
{
	Size : s32;
	Capacity : s32;
	Data : *T;
}

//-----------------------------------------------------------------------------
// ImGuiStyle
// You may modify the ImGui::GetStyle() main instance during initialization and before NewFrame().
// During the frame, use ImGui::PushStyleVar(ImGuiStyleVar_XXXX)/PopStyleVar() to alter the main style values,
// and ImGui::PushStyleColor(ImGuiCol_XXX)/PopStyleColor() for colors.
//-----------------------------------------------------------------------------

// struct member regexp : ([^\s]+)\s+(.*);
// replace with : $2 : $1;

ImGuiStyle :: struct
{
	Alpha : float;                      // Global alpha applies to everything in Dear ImGui.
	WindowPadding : ImVec2;              // Padding within a window.
	WindowRounding : float;             // Radius of window corners rounding. Set to 0.0f to have rectangular windows. Large values tend to lead to variety of artifacts and are not recommended.
	WindowBorderSize : float;           // Thickness of border around windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
	WindowMinSize : ImVec2;              // Minimum window size. This is a global setting. If you want to constraint individual windows, use SetNextWindowSizeConstraints().
	WindowTitleAlign : ImVec2;           // Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
	WindowMenuButtonPosition : ImGuiDir;   // Side of the collapsing/docking button in the title bar (None/Left/Right). Defaults to ImGuiDir_Left.
	ChildRounding : float;              // Radius of child window corners rounding. Set to 0.0f to have rectangular windows.
	ChildBorderSize : float;            // Thickness of border around child windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
	PopupRounding : float;              // Radius of popup window corners rounding. (Note that tooltip windows use WindowRounding)
	PopupBorderSize : float;            // Thickness of border around popup/tooltip windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
	FramePadding : ImVec2;               // Padding within a framed rectangle (used by most widgets).
	FrameRounding : float;              // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
	FrameBorderSize : float;            // Thickness of border around frames. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
	ItemSpacing : ImVec2;                // Horizontal and vertical spacing between widgets/lines.
	ItemInnerSpacing : ImVec2;           // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label).
	TouchExtraPadding : ImVec2;          // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
	IndentSpacing : float;              // Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
	ColumnsMinSpacing : float;          // Minimum horizontal spacing between two columns. Preferably > (FramePadding.x + 1).
	ScrollbarSize : float;              // Width of the vertical scrollbar, Height of the horizontal scrollbar.
	ScrollbarRounding : float;          // Radius of grab corners for scrollbar.
	GrabMinSize : float;                // Minimum width/height of a grab box for slider/scrollbar.
	GrabRounding : float;               // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
	LogSliderDeadzone : float;          // The size in pixels of the dead-zone around zero on logarithmic sliders that cross zero.
	TabRounding : float;                // Radius of upper corners of a tab. Set to 0.0f to have rectangular tabs.
	TabBorderSize : float;              // Thickness of border around tabs.
	TabMinWidthForCloseButton : float;  // Minimum width for close button to appears on an unselected tab when hovered. Set to 0.0f to always show when hovering, set to FLT_MAX to never show close button unless selected.
	ColorButtonPosition : ImGuiDir;        // Side of the color button in the ColorEdit4 widget (left/right). Defaults to ImGuiDir_Right.
	ButtonTextAlign : ImVec2;            // Alignment of button text when button is larger than text. Defaults to (0.5f, 0.5f) (centered).
	SelectableTextAlign : ImVec2;        // Alignment of selectable text. Defaults to (0.0f, 0.0f) (top-left aligned). It's generally important to keep this left-aligned if you want to lay multiple items on a same line.
	DisplayWindowPadding : ImVec2;       // Window position are clamped to be visible within the display area or monitors by at least this amount. Only applies to regular windows.
	DisplaySafeAreaPadding : ImVec2;     // If you cannot see the edges of your screen (e.g. on a TV) increase the safe area padding. Apply to popups/tooltips as well regular windows. NB: Prefer configuring your TV sets correctly!
	MouseCursorScale : float;           // Scale software rendered mouse cursor (when io.MouseDrawCursor is enabled). May be removed later.
	AntiAliasedLines : bool;           // Enable anti-aliased lines/borders. Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
	AntiAliasedLinesUseTex : bool;     // Enable anti-aliased lines/borders using textures where possible. Require back-end to render with bilinear filtering. Latched at the beginning of the frame (copied to ImDrawList).
	AntiAliasedFill : bool;            // Enable anti-aliased edges around filled shapes (rounded rectangles, circles, etc.). Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
	CurveTessellationTol : float;       // Tessellation tolerance when using PathBezierCurveTo() without a specific number of segments. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
	CircleSegmentMaxError : float;      // Maximum error (in pixels) allowed when using AddCircle()/AddCircleFilled() or drawing rounded corner rectangles with no explicit segment count specified. Decrease for higher quality but more geometry.
	Colors : [ImGuiCol.COUNT]ImVec4;
}

//-----------------------------------------------------------------------------
// ImGuiIO
// Communicate most settings and inputs/outputs to Dear ImGui using this structure.
// Access via ImGui::GetIO(). Read 'Programmer guide' section in .cpp file for general usage.
//-----------------------------------------------------------------------------

ImGuiIO :: struct
{
	//------------------------------------------------------------------
	// Configuration (fill once)                // Default value
	//------------------------------------------------------------------

	ConfigFlags : ImGuiConfigFlags;             // = 0              // See ImGuiConfigFlags_ enum. Set by user/application. Gamepad/keyboard navigation options, etc.
	BackendFlags : ImGuiBackendFlags;            // = 0              // See ImGuiBackendFlags_ enum. Set by back-end (imgui_impl_xxx files or custom back-end) to communicate features supported by the back-end.
	DisplaySize : ImVec2;                    // <unset>          // Main display size, in pixels.
	DeltaTime : float;                      // = 1.0f/60.0f     // Time elapsed since last frame, in seconds.
	IniSavingRate : float;                  // = 5.0f           // Minimum time between saving positions/sizes to .ini file, in seconds.
	IniFilename : *u8;                    // = "imgui.ini"    // Path to .ini file. Set NULL to disable automatic .ini loading/saving, if e.g. you want to manually load/save from memory.
	LogFilename : *u8;                    // = "imgui_log.txt"// Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
	MouseDoubleClickTime : float;           // = 0.30f          // Time for a double-click, in seconds.
	MouseDoubleClickMaxDist : float;        // = 6.0f           // Distance threshold to stay in to validate a double-click, in pixels.
	MouseDragThreshold : float;             // = 6.0f           // Distance threshold before considering we are dragging.
	KeyMap : [ImGuiKey.COUNT]s32;         // <unset>          // Map of indices into the KeysDown[512] entries array which represent your "native" keyboard state.
	KeyRepeatDelay : float;                 // = 0.250f         // When holding a key/button, time before it starts repeating, in seconds (for buttons in Repeat mode, etc.).
	KeyRepeatRate : float;                  // = 0.050f         // When holding a key/button, rate at which it repeats, in seconds.
	UserData : *void;                       // = NULL           // Store your own data for retrieval by callbacks.

	Fonts : *ImFontAtlas;                          // <auto>           // Font atlas: load, rasterize and pack one or more fonts into a single texture.
	FontGlobalScale : float;                // = 1.0f           // Global scale all fonts
	FontAllowUserScaling : bool;           // = false          // Allow user scaling text of individual window with CTRL+Wheel.
	FontDefault : *ImFont;                    // = NULL           // Font to use on NewFrame(). Use NULL to uses Fonts->Fonts[0].
	DisplayFramebufferScale : ImVec2;        // = (1, 1)         // For retina display or other situations where window coordinates are different from framebuffer coordinates. This generally ends up in ImDrawData::FramebufferScale.

	// Miscellaneous options
	MouseDrawCursor : bool;                // = false          // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor). Cannot be easily renamed to 'io.ConfigXXX' because this is frequently used by back-end implementations.
	ConfigMacOSXBehaviors : bool;          // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl (was called io.OptMacOSXBehaviors prior to 1.63)
	ConfigInputTextCursorBlink : bool;     // = true           // Set to false to disable blinking cursor, for users who consider it distracting. (was called: io.OptCursorBlink prior to 1.63)
	ConfigWindowsResizeFromEdges : bool;   // = true           // Enable resizing of windows from their edges and from the lower-left corner. This requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback. (This used to be a per-window ImGuiWindowFlags_ResizeFromAnySide flag)
	ConfigWindowsMoveFromTitleBarOnly : bool; // = false       // [BETA] Set to true to only allow moving windows when clicked+dragged from the title bar. Windows without a title bar are not affected.
	ConfigWindowsMemoryCompactTimer : float;// = 60.0f          // [BETA] Compact window memory usage when unused. Set to -1.0f to disable.

	//------------------------------------------------------------------
	// Platform Functions
	// (the imgui_impl_xxxx back-end files are setting those up for you)
	//------------------------------------------------------------------

	// Optional: Platform/Renderer back-end name (informational only! will be displayed in About Window) + User data for back-end/wrappers to store their own stuff.
	BackendPlatformName : *u8;            // = NULL
	BackendRendererName : *u8;            // = NULL
	BackendPlatformUserData : *void;        // = NULL           // User data for platform back-end
	BackendRendererUserData : *void;        // = NULL           // User data for renderer back-end
	BackendLanguageUserData : *void;        // = NULL           // User data for non C++ programming language back-end

	// Optional: Access OS clipboard
	// (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
	GetClipboardTextFn : (user_data : *void) -> *u8 #c_call;
	SetClipboardTextFn : (user_data : *void, text : *u8) -> void #c_call;
	ClipboardUserData : *void;

	// Optional: Notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME on Windows)
	// (default to use native imm32 api on Windows)
	ImeSetInputScreenPosFn : (x : s32, y : s32) -> void #c_call;
	ImeWindowHandle : *void;                // = NULL           // (Windows) Set this to your HWND to get automatic IME cursor positioning.

	// This is only here to keep ImGuiIO the same size/layout, so that IMGUI_DISABLE_OBSOLETE_FUNCTIONS can exceptionally be used outside of imconfig.h.
	RenderDrawListsFnUnused : *void;

	//------------------------------------------------------------------
	// Input - Fill before calling NewFrame()
	//------------------------------------------------------------------

	MousePos : ImVec2;                       // Mouse position, in pixels. Set to ImVec2(-FLT_MAX, -FLT_MAX) if mouse is unavailable (on another screen, etc.)
	MouseDown : [5]bool;                   // Mouse buttons: 0=left, 1=right, 2=middle + extras (ImGuiMouseButton_COUNT == 5). Dear ImGui mostly uses left and right buttons. Others buttons allows us to track if the mouse is being used by your application + available to user as a convenience via IsMouse** API.
	MouseWheel : float;                     // Mouse wheel Vertical: 1 unit scrolls about 5 lines text.
	MouseWheelH : float;                    // Mouse wheel Horizontal. Most users don't have a mouse with an horizontal wheel, may not be filled by all back-ends.
	KeyCtrl : bool;                        // Keyboard modifier pressed: Control
	KeyShift : bool;                       // Keyboard modifier pressed: Shift
	KeyAlt : bool;                         // Keyboard modifier pressed: Alt
	KeySuper : bool;                       // Keyboard modifier pressed: Cmd/Super/Windows
	KeysDown : [512]bool;                  // Keyboard keys that are pressed (ideally left in the "native" order your engine has access to keyboard keys, so you can use your own defines/enums for keys).
	NavInputs : [ImGuiNavInput.COUNT]float; // Gamepad inputs. Cleared back to zero by EndFrame(). Keyboard keys will be auto-mapped and be written here by NewFrame().

	//------------------------------------------------------------------
	// Output - Updated by NewFrame() or EndFrame()/Render()
	// (when reading from the io.WantCaptureMouse, io.WantCaptureKeyboard flags to dispatch your inputs, it is
	//  generally easier and more correct to use their state BEFORE calling NewFrame(). See FAQ for details!)
	//------------------------------------------------------------------

	WantCaptureMouse : bool;               // Set when Dear ImGui will use mouse inputs, in this case do not dispatch them to your main game/application (either way, always pass on mouse inputs to imgui). (e.g. unclicked mouse is hovering over an imgui window, widget is active, mouse was clicked over an imgui window, etc.).
	WantCaptureKeyboard : bool;            // Set when Dear ImGui will use keyboard inputs, in this case do not dispatch them to your main game/application (either way, always pass keyboard inputs to imgui). (e.g. InputText active, or an imgui window is focused and navigation is enabled, etc.).
	WantTextInput : bool;                  // Mobile/console: when set, you may display an on-screen keyboard. This is set by Dear ImGui when it wants textual keyboard input to happen (e.g. when a InputText widget is active).
	WantSetMousePos : bool;                // MousePos has been altered, back-end should reposition mouse on next frame. Rarely used! Set only when ImGuiConfigFlags_NavEnableSetMousePos flag is enabled.
	WantSaveIniSettings : bool;            // When manual .ini load/save is active (io.IniFilename == NULL), this will be set to notify your application that you can call SaveIniSettingsToMemory() and save yourself. Important: clear io.WantSaveIniSettings yourself after saving!
	NavActive : bool;                      // Keyboard/Gamepad navigation is currently allowed (will handle ImGuiKey_NavXXX events) = a window is focused and it doesn't use the ImGuiWindowFlags_NoNavInputs flag.
	NavVisible : bool;                     // Keyboard/Gamepad navigation is visible and allowed (will handle ImGuiKey_NavXXX events).
	Framerate : float;                      // Application framerate estimate, in frame per second. Solely for convenience. Rolling average estimation based on io.DeltaTime over 120 frames.
	MetricsRenderVertices : s32;          // Vertices output during last call to Render()
	MetricsRenderIndices : s32;           // Indices output during last call to Render() = number of triangles * 3
	MetricsRenderWindows : s32;           // Number of visible windows
	MetricsActiveWindows : s32;           // Number of active windows
	MetricsActiveAllocations : s32;       // Number of active allocations, updated by MemAlloc/MemFree based on current context. May be off if you have multiple imgui contexts.
	MouseDelta : ImVec2;                     // Mouse delta. Note that this is zero if either current or previous position are invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a huge delta.

	//------------------------------------------------------------------
	// [Internal] Dear ImGui will maintain those fields. Forward compatibility not guaranteed!
	//------------------------------------------------------------------

	KeyMods : ImGuiKeyModFlags;                   // Key mods flags (same as io.KeyCtrl/KeyShift/KeyAlt/KeySuper but merged into flags), updated by NewFrame()
	MousePosPrev : ImVec2;                   // Previous mouse position (note that MouseDelta is not necessary == MousePos-MousePosPrev, in case either position is invalid)
	MouseClickedPos : [5]ImVec2;             // Position at time of clicking
	MouseClickedTime : [5]float64;            // Time of last click (used to figure out double-click)
	MouseClicked : [5]bool;                // Mouse button went from !Down to Down
	MouseDoubleClicked : [5]bool;          // Has mouse button been double-clicked?
	MouseReleased : [5]bool;               // Mouse button went from Down to !Down
	MouseDownOwned : [5]bool;              // Track if button was clicked inside a dear imgui window. We don't request mouse capture from the application if click started outside ImGui bounds.
	MouseDownWasDoubleClick : [5]bool;     // Track if button down was a double-click
	MouseDownDuration : [5]float;           // Duration the mouse button has been down (0.0f == just clicked)
	MouseDownDurationPrev : [5]float;       // Previous time the mouse button has been down
	MouseDragMaxDistanceAbs : [5]ImVec2;     // Maximum distance, absolute, on each axis, of how much mouse has traveled from the clicking point
	MouseDragMaxDistanceSqr : [5]float;     // Squared maximum distance of how much mouse has traveled from the clicking point
	KeysDownDuration : [512]float;          // Duration the keyboard key has been down (0.0f == just pressed)
	KeysDownDurationPrev : [512]float;      // Previous duration the key has been down
	NavInputsDownDuration : [ImGuiNavInput.COUNT]float;
	NavInputsDownDurationPrev : [ImGuiNavInput.COUNT]float;
	PenPressure : float;                    // Touch/Pen pressure (0.0f to 1.0f, should be >0.0f only when MouseDown[0] == true). Helper storage currently unused by Dear ImGui.
	InputQueueSurrogate : u16;            // For AddInputCharacterUTF16
	InputQueueCharacters : ImVector (ImWchar);     // Queue of _characters_ input (obtained by platform back-end). Fill using AddInputCharacter() helper.
}

//-----------------------------------------------------------------------------
// Misc data structures
//-----------------------------------------------------------------------------

// Shared state of InputText(), passed as an argument to your callback when a ImGuiInputTextFlags_Callback* flag is used.
// The callback function should return 0 by default.
// Callbacks (follow a flag name and see comments in ImGuiInputTextFlags_ declarations for more details)
// - ImGuiInputTextFlags_CallbackEdit:        Callback on buffer edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
// - ImGuiInputTextFlags_CallbackAlways:      Callback on each iteration
// - ImGuiInputTextFlags_CallbackCompletion:  Callback on pressing TAB
// - ImGuiInputTextFlags_CallbackHistory:     Callback on pressing Up/Down arrows
// - ImGuiInputTextFlags_CallbackCharFilter:  Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
// - ImGuiInputTextFlags_CallbackResize:      Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow.

ImGuiInputTextCallbackData :: struct
{
	EventFlag : ImGuiInputTextFlags;      // One ImGuiInputTextFlags_Callback*    // Read-only
	Flags : ImGuiInputTextFlags;          // What user passed to InputText()      // Read-only
	UserData : *void;       // What user passed to InputText()      // Read-only

	// Arguments for the different callback events
	// - To modify the text buffer in a callback, prefer using the InsertChars() / DeleteChars() function. InsertChars() will take care of calling the resize callback if necessary.
	// - If you know your edits are not going to resize the underlying buffer allocation, you may modify the contents of 'Buf[]' directly. You need to update 'BufTextLen' accordingly (0 <= BufTextLen < BufSize) and set 'BufDirty'' to true so InputText can update its internal state.
	EventChar : ImWchar;      // Character input                      // Read-write   // [CharFilter] Replace character with another one, or set to zero to drop. return 1 is equivalent to setting EventChar=0;
	EventKey : ImGuiKey;       // Key pressed (Up/Down/TAB)            // Read-only    // [Completion,History]
	Buf : *u8;            // Text buffer                          // Read-write   // [Resize] Can replace pointer / [Completion,History,Always] Only write to pointed data, don't replace the actual pointer!
	BufTextLen : s32;     // Text length (in bytes)               // Read-write   // [Resize,Completion,History,Always] Exclude zero-terminator storage. In C land: == strlen(some_text), in C++ land: string.length()
	BufSize : s32;        // Buffer size (in bytes) = capacity+1  // Read-only    // [Resize,Completion,History,Always] Include zero-terminator storage. In C land == ARRAYSIZE(my_char_array), in C++ land: string.capacity()+1
	BufDirty : bool;       // Set if you modify Buf/BufTextLen!    // Write        // [Completion,History,Always]
	CursorPos : s32;      //                                      // Read-write   // [Completion,History,Always]
	SelectionStart : s32; //                                      // Read-write   // [Completion,History,Always] == to SelectionEnd when no selection)
	SelectionEnd : s32;   //                                      // Read-write   // [Completion,History,Always]
}

// Resizing callback data to apply custom constraint. As enabled by SetNextWindowSizeConstraints(). Callback is called during the next Begin().
// NB: For basic min/max size constraint on each axis you don't need to use the callback! The SetNextWindowSizeConstraints() parameters are enough.
ImGuiSizeCallbackData :: struct
{
	UserData : *void;       // Read-only.   What user passed to SetNextWindowSizeConstraints()
	Pos : ImVec2;            // Read-only.   Window position, for reference.
	CurrentSize : ImVec2;    // Read-only.   Current window size.
	DesiredSize : ImVec2;    // Read-write.  Desired size, based on user's mouse position. Write to this field to restrain resizing.
}

// Data payload for Drag and Drop operations: AcceptDragDropPayload(), GetDragDropPayload()
ImGuiPayload :: struct
{
	// Members
	Data : *void;               // Data (copied and owned by dear imgui)
	DataSize : s32;           // Data size

	// [Internal]
	SourceId : ImGuiID;           // Source item id
	SourceParentId : ImGuiID;     // Source parent id (if available)
	DataFrameCount : s32;     // Data timestamp
	DataType : [32 + 1]u8;   // Data type tag (short user-supplied string, 32 characters max)
	Preview : bool;            // Set when AcceptDragDropPayload() was called and mouse has been hovering the target item (nb: handle overlapping drag targets)
	Delivery : bool;           // Set when AcceptDragDropPayload() was called and mouse button is released over the target item.
}

//-----------------------------------------------------------------------------
// Helpers
//-----------------------------------------------------------------------------

IM_UNICODE_CODEPOINT_MAX :: cast (u16) 0xffff;     // Maximum Unicode code point supported by this build.

// Helper: Execute a block of code at maximum once a frame. Convenient if you want to quickly create an UI within deep-nested code that runs multiple times every frame.
// Usage: static ImGuiOnceUponAFrame oaf; if (oaf) ImGui::Text("This will be called only once per frame");
ImGuiOnceUponAFrame :: struct
{
	RefFrame : s32 = -1;
}

once :: inline (using uoa : *ImGuiOnceUponAFrame) -> bool
{
	current_frame := ImGui_GetFrameCount ();
	if RefFrame == current_frame then return false;
	RefFrame = current_frame;

	return true;
}

// Helper: Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
ImGuiTextFilter :: struct
{
	// [Internal]
	ImGuiTextRange :: struct
	{
		b : *u8;
		e : *u8;
	}
	
	InputBuf : [256]u8;
	Filters : ImVector (ImGuiTextRange);
	CountGrep : s32;
}

// Helper: Manually clip large list of items.
// If you are submitting lots of evenly spaced items and you have a random access to the list, you can perform coarse
// clipping based on visibility to save yourself from processing those items at all.
// The clipper calculates the range of visible items and advance the cursor to compensate for the non-visible items we have skipped.
// (Dear ImGui already clip items based on their bounds but it needs to measure text size to do so, whereas manual coarse clipping before submission makes this cost and your own data fetching/submission cost almost null)
// Usage:
//   ImGuiListClipper clipper;
//   clipper.Begin(1000);         // We have 1000 elements, evenly spaced.
//   while (clipper.Step())
//       for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
//           ImGui::Text("line number %d", i);
// Generally what happens is:
// - Clipper lets you process the first element (DisplayStart = 0, DisplayEnd = 1) regardless of it being visible or not.
// - User code submit one element.
// - Clipper can measure the height of the first element
// - Clipper calculate the actual range of elements to display based on the current clipping rectangle, position the cursor before the first visible element.
// - User code submit visible elements.
ImGuiListClipper :: struct
{
	DisplayStart : s32;
	DisplayEnd : s32;

	// [Internal]
	ItemsCount : s32;
	StepNo : s32;
	ItemsHeight : float;
	StartPosY : float;
}

//-----------------------------------------------------------------------------
// Draw List API (ImDrawCmd, ImDrawIdx, ImDrawVert, ImDrawChannel, ImDrawListSplitter, ImDrawListFlags, ImDrawList, ImDrawData)
// Hold a series of drawing commands. The user provides a renderer for ImDrawData which essentially contains an array of ImDrawList.
//-----------------------------------------------------------------------------

// The maximum line width to bake anti-aliased textures for. Build atlas with ImFontAtlasFlags_NoBakedLines to disable baking.
IM_DRAWLIST_TEX_LINES_WIDTH_MAX :: 63;

// ImDrawCallback: Draw callbacks for advanced uses [configurable type: override in imconfig.h]
// NB: You most likely do NOT need to use draw callbacks just to create your own widget or customized UI rendering,
// you can poke into the draw list for that! Draw callback may be useful for example to:
//  A) Change your GPU render state,
//  B) render a complex 3D scene inside a UI element without an intermediate texture/render target, etc.
// The expected behavior from your rendering function is 'if (cmd.UserCallback != NULL) { cmd.UserCallback(parent_list, cmd); } else { RenderTriangles() }'
// If you want to override the signature of ImDrawCallback, you can simply use e.g. '#define ImDrawCallback MyDrawCallback' (in imconfig.h) + update rendering back-end accordingly.
ImDrawCallback :: #type (parent_list : *ImDrawList, cmd : *ImDrawCmd) -> void #c_call;

// Special Draw callback value to request renderer back-end to reset the graphics/render state.
// The renderer back-end needs to handle this special value, otherwise it will crash trying to call a function at this address.
// This is useful for example if you submitted callbacks which you know have altered the render state and you want it to be restored.
// It is not done by default because they are many perfectly useful way of altering render state for imgui contents (e.g. changing shader/blending settings before an Image call).
ImDrawCallback_ResetRenderState :: -1;

// Typically, 1 command = 1 GPU draw call (unless command is a callback)
// - VtxOffset/IdxOffset: When 'io.BackendFlags & ImGuiBackendFlags_RendererHasVtxOffset' is enabled,
//   those fields allow us to render meshes larger than 64K vertices while keeping 16-bit indices.
//   Pre-1.71 back-ends will typically ignore the VtxOffset/IdxOffset fields.
// - The ClipRect/TextureId/VtxOffset fields must be contiguous as we memcmp() them together (this is asserted for).
ImDrawCmd :: struct
{
	ClipRect : ImVec4;           // 4*4  // Clipping rectangle (x1, y1, x2, y2). Subtract ImDrawData->DisplayPos to get clipping rectangle in "viewport" coordinates
	TextureId : ImTextureID;          // 4-8  // User-provided texture ID. Set by user in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
	VtxOffset : u32;          // 4    // Start offset in vertex buffer. ImGuiBackendFlags_RendererHasVtxOffset: always 0, otherwise may be >0 to support meshes larger than 64K vertices with 16-bit indices.
	IdxOffset : u32;          // 4    // Start offset in index buffer. Always equal to sum of ElemCount drawn so far.
	ElemCount : u32;          // 4    // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored in the callee ImDrawList's vtx_buffer[] array, indices in idx_buffer[].
	UserCallback : ImDrawCallback;       // 4-8  // If != NULL, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
	UserCallbackData : *void;   // 4-8  // The draw callback code can access this.

	//ImDrawCmd() { memset(this, 0, sizeof(*this)); } // Also ensure our padding fields are zeroed
}

ImDrawIdx :: u16;

ImDrawVert :: struct
{
	pos : ImVec2;
	uv : ImVec2;
	col : u32;
}

// For use by ImDrawListSplitter.
ImDrawChannel :: struct
{
	_CmdBuffer : ImVector (ImDrawCmd);
	_IdxBuffer : ImVector (ImDrawIdx);
}

// Split/Merge functions are used to split the draw list into different layers which can be drawn into out of order.
// This is used by the Columns api, so items of each column can be batched together in a same draw call.
ImDrawListSplitter :: struct
{
	_Current : s32;    // Current channel number (0)
	_Count : s32;      // Number of active channels (1+)
	_Channels : ImVector (ImDrawChannel);   // Draw channels (not resized down so _Count might be < Channels.Size)
}

ImDrawCornerFlags :: enum_flags s32
{
	None      :: 0;
	TopLeft   :: 1 << 0; // 0x1
	TopRight  :: 1 << 1; // 0x2
	BotLeft   :: 1 << 2; // 0x4
	BotRight  :: 1 << 3; // 0x8
	Top       :: ImDrawCornerFlags.TopLeft | .TopRight;   // 0x3
	Bot       :: ImDrawCornerFlags.BotLeft | .BotRight;   // 0xc
	Left      :: ImDrawCornerFlags.TopLeft | .BotLeft;    // 0x5
	Right     :: ImDrawCornerFlags.TopRight | .BotRight;  // 0xa
	All       :: 0xf;     // In your function calls you may use ~0 (= all bits sets) instead of ImDrawCornerFlags_All, as a convenience
}

// Flags for ImDrawList. Those are set automatically by ImGui:: functions from ImGuiIO settings, and generally not manipulated directly.
// It is however possible to temporarily alter flags between calls to ImDrawList:: functions.
ImDrawListFlags :: enum_flags s32
{
	None                    :: 0;
	AntiAliasedLines        :: 1 << 0;  // Enable anti-aliased lines/borders (*2 the number of triangles for 1.0f wide line or lines thin enough to be drawn using textures, otherwise *3 the number of triangles)
	AntiAliasedLinesUseTex  :: 1 << 1;  // Enable anti-aliased lines/borders using textures when possible. Require back-end to render with bilinear filtering.
	AntiAliasedFill         :: 1 << 2;  // Enable anti-aliased edge around filled shapes (rounded rectangles, circles).
	AllowVtxOffset          :: 1 << 3;  // Can emit 'VtxOffset > 0' to allow large meshes. Set when 'ImGuiBackendFlags_RendererHasVtxOffset' is enabled.
}

// Draw command list
// This is the low-level list of polygons that ImGui:: functions are filling. At the end of the frame,
// all command lists are passed to your ImGuiIO::RenderDrawListFn function for rendering.
// Each dear imgui window contains its own ImDrawList. You can use ImGui::GetWindowDrawList() to
// access the current window draw list and draw custom primitives.
// You can interleave normal ImGui:: calls and adding primitives to the current draw list.
// All positions are generally in pixel coordinates (top-left at (0,0), bottom-right at io.DisplaySize), but you are totally free to apply whatever transformation matrix to want to the data (if you apply such transformation you'll want to apply it to ClipRect as well)
// Important: Primitives are always added to the list and not culled (culling is done at higher-level by ImGui:: functions), if you use this API a lot consider coarse culling your drawn objects.
ImDrawList :: struct
{
	// This is what you have to render
	CmdBuffer : ImVector (ImDrawCmd);          // Draw commands. Typically 1 command = 1 GPU draw call, unless the command is a callback.
	IdxBuffer : ImVector (ImDrawIdx);          // Index buffer. Each command consume ImDrawCmd::ElemCount of those
	VtxBuffer : ImVector (ImDrawVert);          // Vertex buffer.
	Flags : ImDrawListFlags;              // Flags, you may poke into these to adjust anti-aliasing settings per-primitive.

	// [Internal, used while building lists]
	_Data : *ImDrawListSharedData;          // Pointer to shared draw data (you can use ImGui::GetDrawListSharedData() to get the one from current ImGui context)
	_OwnerName : *u8;         // Pointer to owner window's name for debugging
	_VtxCurrentIdx : u32;     // [Internal] Generally == VtxBuffer.Size unless we are past 64K vertices, in which case this gets reset to 0.
	_VtxWritePtr : *ImDrawVert;       // [Internal] point within VtxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
	_IdxWritePtr : *ImDrawIdx;       // [Internal] point within IdxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
	_ClipRectStack : ImVector (ImVec4);     // [Internal]
	_TextureIdStack : ImVector (ImTextureID);    // [Internal]
	_Path : ImVector (ImVec2);              // [Internal] current path building
	_CmdHeader : ImDrawCmd;         // [Internal] Template of active commands. Fields should match those of CmdBuffer.back().
	_Splitter : ImDrawListSplitter;          // [Internal] for channels api (note: prefer using your own persistent instance of ImDrawListSplitter!)
}

ImDrawListSharedData :: struct {};

// All draw data to render a Dear ImGui frame
// (NB: the style and the naming convention here is a little inconsistent, we currently preserve them for backward compatibility purpose,
// as this is one of the oldest structure exposed by the library! Basically, ImDrawList == CmdList)
ImDrawData :: struct
{
	Valid : bool;                  // Only valid after Render() is called and before the next NewFrame() is called.
	CmdLists : **ImDrawList;               // Array of ImDrawList* to render. The ImDrawList are owned by ImGuiContext and only pointed to from here.
	CmdListsCount : s32;          // Number of ImDrawList* to render
	TotalIdxCount : s32;          // For convenience, sum of all ImDrawList's IdxBuffer.Size
	TotalVtxCount : s32;          // For convenience, sum of all ImDrawList's VtxBuffer.Size
	DisplayPos : ImVec2;             // Upper-left position of the viewport to render (== upper-left of the orthogonal projection matrix to use)
	DisplaySize : ImVec2;            // Size of the viewport to render (== io.DisplaySize for the main viewport) (DisplayPos + DisplaySize == lower-right of the orthogonal projection matrix to use)
	FramebufferScale : ImVec2;       // Amount of pixels for each unit of DisplaySize. Based on io.DisplayFramebufferScale. Generally (1,1) on normal display, (2,2) on OSX with Retina display.
}


//-----------------------------------------------------------------------------
// Font API (ImFontConfig, ImFontGlyph, ImFontAtlasFlags, ImFontAtlas, ImFontGlyphRangesBuilder, ImFont)
//-----------------------------------------------------------------------------

ImFontConfig :: struct
{
	FontData : *void;               //          // TTF/OTF data
	FontDataSize : s32;           //          // TTF/OTF data size
	FontDataOwnedByAtlas : bool;   // true     // TTF/OTF data ownership taken by the container ImFontAtlas (will delete memory itself).
	FontNo : s32;                 // 0        // Index of font within TTF/OTF file
	SizePixels : float;             //          // Size in pixels for rasterizer (more or less maps to the resulting font height).
	OversampleH : s32;            // 3        // Rasterize at higher quality for sub-pixel positioning. Read https://github.com/nothings/stb/blob/master/tests/oversample/README.md for details.
	OversampleV : s32;            // 1        // Rasterize at higher quality for sub-pixel positioning. We don't use sub-pixel positions on the Y axis.
	PixelSnapH : bool;             // false    // Align every glyph to pixel boundary. Useful e.g. if you are merging a non-pixel aligned font with the default font. If enabled, you can set OversampleH/V to 1.
	GlyphExtraSpacing : ImVec2;      // 0, 0     // Extra spacing (in pixels) between glyphs. Only X axis is supported for now.
	GlyphOffset : ImVec2;            // 0, 0     // Offset all glyphs from this font input.
	GlyphRanges : *ImWchar;            // NULL     // Pointer to a user-provided list of Unicode range (2 value per range, values are inclusive, zero-terminated list). THE ARRAY DATA NEEDS TO PERSIST AS LONG AS THE FONT IS ALIVE.
	GlyphMinAdvanceX : float;       // 0        // Minimum AdvanceX for glyphs, set Min to align font icons, set both Min/Max to enforce mono-space font
	GlyphMaxAdvanceX : float;       // FLT_MAX  // Maximum AdvanceX for glyphs
	MergeMode : bool;              // false    // Merge into previous ImFont, so you can combine multiple inputs font into one ImFont (e.g. ASCII font + icons + Japanese glyphs). You may want to use GlyphOffset.y when merge font of different heights.
	RasterizerFlags : u32;        // 0x00     // Settings for custom font rasterizer (e.g. ImGuiFreeType). Leave as zero if you aren't using one.
	RasterizerMultiply : float;     // 1.0f     // Brighten (>1.0f) or darken (<1.0f) font output. Brightening small fonts may be a good workaround to make them more readable.
	EllipsisChar : ImWchar;           // -1       // Explicitly specify unicode codepoint of ellipsis character. When fonts are being merged first specified ellipsis will be used.

	// [Internal]
	Name : [40]u8;               // Name (strictly to ease debugging)
	DstFont : *ImFont;
}

// Hold rendering data for one glyph.
// (Note: some language parsers may fail to convert the 31+1 bitfield members, in this case maybe drop store a single u32 or we can rework this)
ImFontGlyph :: struct
{
	Codepoint : u32;
	//unsigned int    Codepoint : 31;     // 0x0000..0xFFFF
	//unsigned int    Visible : 1;        // Flag to allow early out when rendering
	AdvanceX : float;           // Distance to next character (= data from font + ImFontConfig::GlyphExtraSpacing.x baked in)
	X0, Y0, X1, Y1 : float;     // Glyph corners
	U0, V0, U1, V1 : float;     // Texture coordinates
}

// Helper to build glyph ranges from text/string data. Feed your application strings/characters to it then call BuildRanges().
// This is essentially a tightly packed of vector of 64k booleans = 8KB storage.
ImFontGlyphRangesBuilder :: struct
{
	UsedChars : ImVector (u32);            // Store 1-bit per Unicode code point (0=unused, 1=used)
}

// See ImFontAtlas::AddCustomRectXXX functions.
ImFontAtlasCustomRect :: struct
{
	Width, Height : u16;  // Input    // Desired rectangle dimension
	X, Y : u16;           // Output   // Packed position in Atlas
	GlyphID : u32;        // Input    // For custom font glyphs only (ID < 0x110000)
	GlyphAdvanceX : float;  // Input    // For custom font glyphs only: glyph xadvance
	GlyphOffset : ImVec2;    // Input    // For custom font glyphs only: glyph display offset
	Font : *ImFont;           // Input    // For custom font glyphs only: target font
}

// Flags for ImFontAtlas build
ImFontAtlasFlags :: enum_flags s32
{
	None               :: 0;
	NoPowerOfTwoHeight :: 1 << 0;   // Don't round the height to next power of two
	NoMouseCursors     :: 1 << 1;   // Don't build software mouse cursors into the atlas (save a little texture memory)
	NoBakedLines       :: 1 << 2;   // Don't build thick line textures into the atlas (save a little texture memory). The AntiAliasedLinesUseTex features uses them, otherwise they will be rendered using polygons (more expensive for CPU/GPU).
}

// Load and rasterize multiple TTF/OTF fonts into a same texture. The font atlas will build a single texture holding:
//  - One or more fonts.
//  - Custom graphics data needed to render the shapes needed by Dear ImGui.
//  - Mouse cursor shapes for software cursor rendering (unless setting 'Flags |= ImFontAtlasFlags_NoMouseCursors' in the font atlas).
// It is the user-code responsibility to setup/build the atlas, then upload the pixel data into a texture accessible by your graphics api.
//  - Optionally, call any of the AddFont*** functions. If you don't call any, the default font embedded in the code will be loaded for you.
//  - Call GetTexDataAsAlpha8() or GetTexDataAsRGBA32() to build and retrieve pixels data.
//  - Upload the pixels data into a texture within your graphics system (see imgui_impl_xxxx.cpp examples)
//  - Call SetTexID(my_tex_id); and pass the pointer/identifier to your texture in a format natural to your graphics API.
//    This value will be passed back to you during rendering to identify the texture. Read FAQ entry about ImTextureID for more details.
// Common pitfalls:
// - If you pass a 'glyph_ranges' array to AddFont*** functions, you need to make sure that your array persist up until the
//   atlas is build (when calling GetTexData*** or Build()). We only copy the pointer, not the data.
// - Important: By default, AddFontFromMemoryTTF() takes ownership of the data. Even though we are not writing to it, we will free the pointer on destruction.
//   You can set font_cfg->FontDataOwnedByAtlas=false to keep ownership of your data and it won't be freed,
// - Even though many functions are suffixed with "TTF", OTF data is supported just as well.
// - This is an old API and it is currently awkward for those and and various other reasons! We will address them in the future!
ImFontAtlas :: struct
{
	//-------------------------------------------
	// Members
	//-------------------------------------------

	Locked : bool;             // Marked as Locked by ImGui::NewFrame() so attempt to modify the atlas will assert.
	Flags : ImFontAtlasFlags;              // Build flags (see ImFontAtlasFlags_)
	TexID : ImTextureID;              // User data to refer to the texture once it has been uploaded to user's graphic systems. It is passed back to you during rendering via the ImDrawCmd structure.
	TexDesiredWidth : s32;    // Texture width desired by user before Build(). Must be a power-of-two. If have many glyphs your graphics API have texture size restrictions you may want to increase texture width to decrease height.
	TexGlyphPadding : s32;    // Padding between glyphs within texture in pixels. Defaults to 1. If your rendering method doesn't rely on bilinear filtering you may set this to 0.

	// [Internal]
	// NB: Access texture data via GetTexData*() calls! Which will setup a default font for you.
	TexPixelsAlpha8 : *u8;    // 1 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight
	TexPixelsRGBA32 : *s32;    // 4 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight * 4
	TexWidth : s32;           // Texture width calculated during Build().
	TexHeight : s32;          // Texture height calculated during Build().
	TexUvScale : ImVec2;         // = (1.0f/TexWidth, 1.0f/TexHeight)
	TexUvWhitePixel : ImVec2;    // Texture coordinates to a white pixel
	Fonts : ImVector (*ImFont);              // Hold all the fonts returned by AddFont*. Fonts[0] is the default font upon calling ImGui::NewFrame(), use ImGui::PushFont()/PopFont() to change the current font.
	CustomRects : ImVector (ImFontAtlasCustomRect);    // Rectangles for packing custom texture data into the atlas.
	ConfigData : ImVector (ImFontConfig);         // Configuration data
	TexUvLines : [IM_DRAWLIST_TEX_LINES_WIDTH_MAX + 1]ImVec4;  // UVs for baked anti-aliased lines

	// [Internal] Packing data
	PackIdMouseCursors : s32; // Custom texture rectangle ID for white pixel and mouse cursors
	PackIdLines : s32;        // Custom texture rectangle ID for baked anti-aliased lines
}

// Font runtime data and rendering
// ImFontAtlas automatically loads a default embedded font for you when you call GetTexDataAsAlpha8() or GetTexDataAsRGBA32().
ImFont :: struct
{
	// Members: Hot ~20/24 bytes (for CalcTextSize)
	IndexAdvanceX : ImVector (float);      // 12-16 // out //            // Sparse. Glyphs->AdvanceX in a directly indexable way (cache-friendly for CalcTextSize functions which only this this info, and are often bottleneck in large UI).
	FallbackAdvanceX : float;   // 4     // out // = FallbackGlyph->AdvanceX
	FontSize : float;           // 4     // in  //            // Height of characters/line, set during loading (don't change after loading)

	// Members: Hot ~28/40 bytes (for CalcTextSize + render loop)
	IndexLookup : ImVector (ImWchar);        // 12-16 // out //            // Sparse. Index glyphs by Unicode code-point.
	Glyphs : ImVector (ImFontGlyph);             // 12-16 // out //            // All glyphs.
	FallbackGlyph : *ImFontGlyph;      // 4-8   // out // = FindGlyph(FontFallbackChar)

	// Members: Cold ~32/40 bytes
	ContainerAtlas : *ImFontAtlas;     // 4-8   // out //            // What we has been loaded into
	ConfigData : *ImFontConfig;         // 4-8   // in  //            // Pointer within ContainerAtlas->ConfigData
	ConfigDataCount : s16;    // 2     // in  // ~ 1        // Number of ImFontConfig involved in creating this font. Bigger than 1 when merging multiple font sources into one ImFont.
	FallbackChar : ImWchar;       // 2     // in  // = '?'      // Replacement character if a glyph isn't found. Only set via SetFallbackChar()
	EllipsisChar : ImWchar;       // 2     // out // = -1       // Character used for ellipsis rendering.
	DirtyLookupTables : bool;  // 1     // out //
	Scale : float;              // 4     // in  // = 1.f      // Base font scale, multiplied by the per-window font scale which you can adjust with SetWindowFontScale()
	Ascent, Descent : float;    // 4+4   // out //            // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
	MetricsTotalSurface : s32;// 4     // out //            // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)
	Used4kPagesMap : [(IM_UNICODE_CODEPOINT_MAX+1)/4096/8]u8; // 2 bytes if ImWchar=ImWchar16, 34 bytes if ImWchar==ImWchar32. Store 1-bit for each block of 4K codepoints that has one active glyph. This is mainly used to facilitate iterations across all used codepoints.
}
