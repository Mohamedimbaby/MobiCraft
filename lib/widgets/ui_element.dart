class UIElement  {
    final String type;
    final Map<String,dynamic>? properties;

    UIElement({required this.type, this.properties});

    @override
    String toString() {
        return 'UIElement(type: $type, properties: $properties)';
    }

    

    
}