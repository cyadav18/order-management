package ecommerce.platform.common;

public enum WeightUnit {
    GRAM("g"),
    KILOGRAM("kg");

    private final String value;

    WeightUnit(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
