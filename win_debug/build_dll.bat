call vcvars64
if not exist dll mkdir dll
pushd dll
call cl /LD /Zi /DEBUG /DIMGUI_BUILD_DLL ../../imgui/imgui.cpp ../../imgui/imgui_draw.cpp ../../imgui/imgui_demo.cpp ../../imgui/imgui_widgets.cpp /link /DLL /OUT:ImGui.dll
del imgui.obj
del imgui_demo.obj
del imgui_draw.obj
del imgui_widgets.obj
popd dll
