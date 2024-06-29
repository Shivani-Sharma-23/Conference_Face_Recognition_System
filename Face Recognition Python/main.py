import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Lambda
from tensorflow.keras.optimizers import Adam
from tensorflow.keras import backend as K

#paths for training and validation directories
train_dir = 'archive//train'
validation_dir = 'archive//validation'


for class_name in os.listdir(train_dir):
    class_path = os.path.join(train_dir, class_name)
    if os.path.isdir(class_path):
        print(f"Class: {class_name}, Number of images: {len(os.listdir(class_path))}")

# Initializing the ImageDataGenerator with data augmentation for training
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=40,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=(224, 224),
    batch_size=2, 
    class_mode='binary'  
)

# Initializing the ImageDataGenerator for validation
validation_datagen = ImageDataGenerator(rescale=1./255)

validation_generator = validation_datagen.flow_from_directory(
    validation_dir,
    target_size=(224, 224),
    batch_size=2,  
    class_mode='binary'
)

# Loading the MobileNetV2 model pre-trained on ImageNet, without the top classification layer
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))


x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(128)(x) 
x = Lambda(lambda x: K.l2_normalize(x, axis=1))(x)


output = Dense(1, activation='sigmoid')(x)

model = Model(inputs=base_model.input, outputs=output)

for layer in base_model.layers:
    layer.trainable = False

model.compile(optimizer=Adam(), loss='binary_crossentropy', metrics=['accuracy'])


batch_x, batch_y = next(train_generator)
print(f"Batch X shape: {batch_x.shape}")
print(f"Batch Y shape: {batch_y.shape if batch_y is not None else 'None'}")

val_batch_x, val_batch_y = next(validation_generator)
print(f"Validation Batch X shape: {val_batch_x.shape}")
print(f"Validation Batch Y shape: {val_batch_y.shape if val_batch_y is not None else 'None'}")

# Train the model
model.fit(train_generator, epochs=10, validation_data=validation_generator)


model.save('face_embedding_model.keras')

