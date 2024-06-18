# Convert the model to TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the TFLite model
with open('mobile_face_net_new.tflite', 'wb') as f:
    f.write(tflite_model)
