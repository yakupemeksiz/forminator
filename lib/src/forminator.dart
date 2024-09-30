import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template forminator}
/// Forminator simplifies form management and validation in Flutter with customizable fields, dynamic error handling, and batch validation, optimizing form creation with advanced features.
/// {@endtemplate}
class Forminator extends StatefulWidget {
  /// {@macro forminator}
  const Forminator({
    super.key,
    this.child,
    this.onChanged,
    this.hideErrorOnFocus = false,
  });

  /// The child widget to be wrapped by the form.
  final Widget? child;

  /// Whether to hide error messages when a field is focused.
  final bool hideErrorOnFocus;

  /// Callback function triggered when any field in the form changes.
  final VoidCallback? onChanged;

  @override
  State<Forminator> createState() => ForminatorState();
}

/// {@template forminator_state}
/// The state of the Forminator widget.
/// This class manages the state of the form, including field registration, validation, and error handling.
/// It also provides methods to validate the form and notify the form when a field changes.
/// It is used to manage the state of the Forminator widget.
/// {@endtemplate}
class ForminatorState extends State<Forminator> {
  final Set<TextForminatorFieldState> _fields = <TextForminatorFieldState>{};

  /// This method validates all the fields in the form and returns true if all are valid.
  /// If any field has an error, it returns false.
  ///
  /// Parameters:
  /// - [forceShowError]: A flag that forces the error to be shown if a field has an error.
  ///
  /// Functionality:
  /// 1. It asserts that there are fields registered in the form, throwing an error if the form is empty.
  /// 2. For each field in the form, it calls the `_validate` method, passing the `forceShowError` parameter.
  /// 3. It returns false if any field has an error, otherwise returns true.
  bool isValid({bool forceShowError = false}) {
    assert(_fields.isNotEmpty, 'No fields registered in the form.');
    return _fields.every((field) {
      field._validate(forceShowError: forceShowError);
      return !field.hasError;
    });
  }

  /// Checks if any field in the `_fields` list has changed from its initial value.
  ///
  /// This getter iterates over the `_fields` list and returns `true` if at least
  /// one field has its `_isInitialTextChanged` flag set to `true`, indicating
  /// that the field's value has been modified since its initial state.
  ///
  /// Returns `true` if any field has changed, otherwise returns `false`.
  bool get isInitialTextChanged {
    return _fields.any((field) => field._isInitialTextChanged);
  }

  /// Registers a [TextForminatorFieldState] with the form.
  void _register(TextForminatorFieldState field) {
    _fields.add(field);
  }

  /// Unregisters a [TextForminatorFieldState] from the form.
  void _unregister(TextForminatorFieldState field) {
    assert(
      _fields.contains(field),
      'Attempting to unregister a field that was not registered.',
    );
    _fields.remove(field);
  }

  /// Notifies the form that a field has changed.
  void fieldDidChange() {
    widget.onChanged?.call();
  }

  /// Finds the nearest [ForminatorState] ancestor in the widget tree.
  static ForminatorState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ForminatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}

/// {@template forminator_text_field}
/// A customizable text field that integrates with Forminator to enable dynamic validation, error management, and flexible interaction handling.
/// {@endtemplate}
class TextForminatorField extends StatefulWidget {
  /// {@macro forminator_text_field}
  const TextForminatorField({
    this.textCapitalization = TextCapitalization.none,
    super.key,
    this.validator,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.decoration = const InputDecoration(),
    this.obscureText = false,
    this.enabled,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorErrorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.statesController,
    this.clipBehavior = Clip.hardEdge,
    this.scribbleEnabled = true,
    this.canRequestFocus = true,
    this.showErrors = true,
    this.onError,
    this.textInputAction,
    this.initialValue,
  });

  /// A function to validate the input text.
  /// If it returns a non-null string, it will be displayed as an error message.
  final String? Function(String?)? validator;

  /// Manages the focus of this field. If null, a new `FocusNode` will be created.
  final FocusNode? focusNode;

  /// Controls the text being edited. If null, a new `TextEditingController` will be created.
  final TextEditingController? controller;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Whether to obscure the text, commonly used for password fields.
  final bool obscureText;

  /// Whether the input field is enabled. If false, the field is read-only.
  final bool? enabled;

  /// Called whenever the input changes.
  final ValueChanged<String>? onChanged;

  /// Called when the input field is tapped.
  final GestureTapCallback? onTap;

  /// Whether the text field should focus itself if nothing else is focused.
  final bool autofocus;

  /// Whether the text field is read-only.
  /// If true, the user cannot modify the text, but they can still select and copy it.
  final bool readOnly;

  /// Whether to show the cursor when this field is not focused.
  final bool? showCursor;

  /// The character used when obscuring text. Defaults to '•'.
  final String obscuringCharacter;

  /// Whether to enable autocorrect for the text field.
  final bool autocorrect;

  /// Enables smart dashes (replacement of regular dashes with typographic dashes).
  final SmartDashesType? smartDashesType;

  /// Enables smart quotes (replacement of straight quotes with typographic quotes).
  final SmartQuotesType? smartQuotesType;

  /// Whether to show input suggestions such as auto-complete.
  final bool enableSuggestions;

  /// Controls how the input length should be enforced, if `maxLength` is specified.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// The maximum number of lines to show at once.
  final int? maxLines;

  /// The minimum number of lines to show at once.
  final int? minLines;

  /// Whether the text field should expand to fill its parent.
  final bool expands;

  /// The maximum number of characters allowed in the text field.
  final int? maxLength;

  /// Whether the onTap callback should always be called, even if the input is not focused.
  final bool onTapAlwaysCalled;

  /// Called when the user taps outside the input field.
  final TapRegionCallback? onTapOutside;

  /// Called when editing is complete (usually when the user presses the enter key).
  final VoidCallback? onEditingComplete;

  /// Called when the user submits the field (e.g., by pressing enter on the keyboard).
  final ValueChanged<String>? onFieldSubmitted;

  /// Called when the field is saved (typically when submitting a form).
  final FormFieldSetter<String>? onSaved;

  /// A list of input formatters to apply to the text field, such as restricting input to numbers.
  final List<TextInputFormatter>? inputFormatters;

  /// The width of the cursor. Defaults to 2.0.
  final double cursorWidth;

  /// The height of the cursor. If null, it defaults to the font height.
  final double? cursorHeight;

  /// The radius of the cursor's rounded corners.
  final Radius? cursorRadius;

  /// The color of the cursor.
  final Color? cursorColor;

  /// The color of the cursor when there is an error.
  final Color? cursorErrorColor;

  /// The appearance of the keyboard (light or dark).
  final Brightness? keyboardAppearance;

  /// The padding to be added to the text field when it is scrolled into view.
  final EdgeInsets scrollPadding;

  /// Whether interactive selection is enabled (e.g., text selection and copy-paste actions).
  final bool? enableInteractiveSelection;

  /// Controls for the selection of text (e.g., cut, copy, paste).
  final TextSelectionControls? selectionControls;

  /// A builder for a widget that displays the character counter below the text field.
  final InputCounterWidgetBuilder? buildCounter;

  /// Scroll physics for the text field (e.g., whether it scrolls freely or locks to lines).
  final ScrollPhysics? scrollPhysics;

  /// Hints to autofill the text field with previously entered data.
  final Iterable<String>? autofillHints;

  /// Controls when the field's validation is triggered (on change, submit, etc.).
  final AutovalidateMode? autovalidateMode;

  /// A controller to manage scrolling of the text field.
  final ScrollController? scrollController;

  /// A restoration ID to restore the state of the text field when it is recreated.
  final String? restorationId;

  /// Whether to enable personalized learning for the keyboard.
  final bool enableIMEPersonalizedLearning;

  /// The mouse cursor to display when hovering over the text field.
  final MouseCursor? mouseCursor;

  /// A builder for customizing the context menu (copy, paste, etc.).
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Configuration for spell checking.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Configuration for the magnifier used when selecting text.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// A controller for managing undo/redo history of the text field.
  final UndoHistoryController? undoController;

  /// A callback for handling private commands sent from the platform.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Whether the cursor's opacity should animate.
  final bool? cursorOpacityAnimates;

  /// Determines the height style of the selection box (tight or loose).
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Determines the width style of the selection box (tight or loose).
  final ui.BoxWidthStyle selectionWidthStyle;

  /// Determines how the field should handle drag gestures.
  final DragStartBehavior dragStartBehavior;

  /// Configuration for handling content insertion (e.g., drag and drop).
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// A controller for handling material state changes (e.g., hover, focus).
  final WidgetStatesController? statesController;

  /// Determines how the content in the field should be clipped (e.g., hard edge, anti-alias).
  final Clip clipBehavior;

  /// Whether to enable the scribble input feature.
  final bool scribbleEnabled;

  /// Whether the field can request focus. If false, it will not be focusable.
  final bool canRequestFocus;

  /// Whether to show errors in the field.
  final bool showErrors;

  /// Callback function triggered when an error occurs.
  final ValueChanged<String?>? onError;

  /// The capitalization of the text field.
  final TextCapitalization textCapitalization;

  /// The text alignment of the text field.
  final TextInputAction? textInputAction;

  /// The initial value of the text field.
  final String? initialValue;

  @override
  State<TextForminatorField> createState() => TextForminatorFieldState();
}

/// {@template forminator_text_field_state}
/// The state of the ForminatorTextFormField widget.
/// This class manages the state of the text field, including focus, error handling, and validation.
/// It also provides methods to validate the field and notify the form when the field changes.
/// {@endtemplate}
class TextForminatorFieldState extends State<TextForminatorField> {
  /// The current state of the Forminator widget.
  ForminatorState? _forminatorState;

  /// Stores the initial value of the field, if available.
  ///
  /// This `late final` variable is intended to hold the initial value of the field.
  /// It is only initialized once and cannot be changed afterward. The value can be `null`
  /// if no initial value is provided. This might be used to track changes in the field
  /// by comparing the current value with `_initialText`.
  ///
  /// Note: Since it's marked as `late`, it must be assigned before it is accessed.
  late final String _initialText;

  /// Tracks whether the initial value of the field has changed.
  ///
  /// This boolean variable is used to determine if the value of the field has been modified
  /// from its original (initial) state. It starts as `false`, meaning no change has occurred.
  /// If the current value differs from the initial value, this flag should be set to `true`.
  ///
  /// This is useful for detecting unsaved changes or triggering updates when the user modifies the field.
  bool _isInitialTextChanged = false;

  /// Indicates whether the field currently has an error.
  bool _isError = false;

  /// Tracks whether the field is currently focused.
  bool _isFocused = false;

  /// Indicates if the field's content has been changed by the user.
  bool _isChanged = false;

  /// Determines whether to hide the error message (used in conjunction with focus).
  bool _hideError = false;

  /// Stores the current error message for the field.
  String? _errorText;

  /// The focus node for this text field, managing its focus state.
  late final FocusNode _focusNode;

  /// The controller for this text field, managing its content.
  late final TextEditingController _controller;

  /// Determines whether to show the error message.
  ///
  /// Error is shown if:
  /// 1. There is an error (_isError is true)
  /// 2. The field has been changed (_isChanged is true)
  /// 3. The error is not explicitly hidden (_hideError is false)
  bool get _showError => _isError && _isChanged && !_hideError && !_isFocused;

  /// Public getter to check if the field currently has an error.
  bool get hasError => _isError;

  /// Determines whether to hide error on focus, based on the CustomForm's setting.
  ///
  /// If this field is not within a CustomForm, defaults to false.
  bool get _hideErrorOnFocus =>
      ForminatorState.maybeOf(context)?.widget.hideErrorOnFocus ?? false;

  /// Handles focus changes and updates error visibility accordingly.
  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      _hideError = _isFocused && _hideErrorOnFocus;
    });

    if (!_isFocused) {
      _validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(_handleFocusChange);
    _initialText = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    _forminatorState = ForminatorState.maybeOf(context);
    _forminatorState?._register(this);
    return TextFormField(
      forceErrorText: widget.showErrors
          ? _showError
              ? _errorText
              : null
          : null,
      focusNode: _focusNode,
      initialValue: widget.initialValue,
      controller: _controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      decoration: widget.decoration,
      dragStartBehavior: widget.dragStartBehavior,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      obscuringCharacter: widget.obscuringCharacter,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      cursorErrorColor: widget.cursorErrorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      scrollController: widget.scrollController,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      mouseCursor: widget.mouseCursor,
      contextMenuBuilder: widget.contextMenuBuilder,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      undoController: widget.undoController,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      statesController: widget.statesController,
      clipBehavior: widget.clipBehavior,
      scribbleEnabled: widget.scribbleEnabled,
      canRequestFocus: widget.canRequestFocus,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onChanged: (value) {
        widget.onChanged?.call(value);
        handleOnChanged(value);
      },
      onTapOutside: (event) {
        widget.onTapOutside?.call(event);
        FocusScope.of(context).unfocus();
      },
    );
  }

  /// Handles the onChanged event of the text field.
  void handleOnChanged(String value) {
    _forminatorState?.fieldDidChange();

    _updateInitialTextValue();

    if (_isChanged) {
      return;
    }

    setState(() {
      _isChanged = true;
    });
  }

  /// Checks if the current value of the field has changed from its initial value.
  /// If the value has changed, it emits a status update indicating the change.
  ///
  /// This function compares the initial value of the field with the current value in the controller.
  /// If they are different, it triggers a status change to `true`, otherwise `false`.
  void _updateInitialTextValue() {
    if (_forminatorState != null) {
      for (final field in _forminatorState!._fields) {
        if (field._controller.hashCode == _controller.hashCode) {
          if (field._initialText != _controller.text) {
            _emitInitialTextValueStatus(true);
          }

          if (field._initialText == _controller.text) {
            _emitInitialTextValueStatus(false);
          }
        }
      }
    }
  }

  /// Updates the internal state to reflect whether the initial value of the field has changed.
  /// The provided [status] determines if the value is considered changed (true) or unchanged (false).
  ///
  /// This method triggers a state change to update the UI based on the value change status.
  void _emitInitialTextValueStatus(bool status) {
    setState(() {
      _isInitialTextChanged = status;
    });
  }

  /// Validates the field using the provided validator function.
  ///
  /// @param forceShowError If true, forces the error to be shown even if it would normally be hidden.
  void _validate({bool forceShowError = false}) {
    // Check if a validator function is provided
    if (widget.validator != null) {
      // Call the validator function with the current text
      final error = widget.validator!(_controller.text);

      setState(() {
        // Update error state based on validator result
        _isError = error != null;
        _errorText = error ?? ''; // Use empty string if error is null
      });

      // If forceShowError is true, ensure the error is not hidden
      if (forceShowError) {
        setState(() {
          _hideError = false;
          _isFocused = false;
          _isChanged = true;
        });
        widget.onError?.call(error);
      }

      if (!_focusNode.hasFocus && _isChanged) {
        widget.onError?.call(error);
      }
    }
  }

  @override
  void didUpdateWidget(TextForminatorField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the controller changes, remove the listener from the old controller and add it to the new one.
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_validate);
      widget.controller?.addListener(_validate);
    }

    // When the focusNode changes, remove the listener from the old focusNode and add it to the new one.
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      widget.focusNode?.addListener(_handleFocusChange);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safely get a reference to the ForminatorState and register this field in it.
    _forminatorState = ForminatorState.maybeOf(context);
    _forminatorState?._register(this);
  }

  @override
  void dispose() {
    // If the widget is using a locally created focusNode, dispose of it to free up resources.
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    // If the widget is using a locally created controller, dispose of it to free up resources.
    if (widget.controller == null) {
      _controller.dispose();
    }

    // Remove the focus change listener to avoid memory leaks after the widget is destroyed.
    _focusNode.removeListener(_handleFocusChange);

    // Unregister this field from the ForminatorState when the widget is disposed.
    _forminatorState?._unregister(this);

    // Call the parent dispose method to ensure any additional cleanup is handled.
    super.dispose();
  }
}
